//
//  Day15.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 20/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day15: Day {
    static let divisor = 2147483647
    static let factors = [
        "A": 16807,
        "B": 48271
    ]

    static func part1(input: String) -> String {
        let generators = parse(input)

        let initialA = generators.first!.1
        let initialB = generators.last!.1
        let factorA = factors["A"]!
        let factorB = factors["B"]!

        let result = (0..<40_000_000).reduce((a: initialA, b: initialB, matches: 0)) { state, times in
            let newA = (state.a * factorA) % divisor
            let newB = (state.b * factorB) % divisor
            return (newA, newB, state.matches + (judge(newA, newB) ? 1 : 0))
        }

        return "\(result.matches)"
    }

    static func part2(input: String) -> String {
        return ""
    }

    static func judge(_ a: Int, _ b: Int) -> Bool {
        let mask = 0b1111111111111111
        return a & mask == b & mask
    }

    static func parse(_ input: String) -> [(String, Int)] {
        return input.components(separatedBy: .newlines).nonEmptyLines().map {
            let lineTokens = $0.components(separatedBy: .whitespaces)
            let name = lineTokens[1]
            let startValue = Int(lineTokens.last!)!
            return (name, startValue)
        }
    }
}
