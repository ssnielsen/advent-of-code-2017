//
//  Day14.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 15/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day14: Day {
    static func part1(input: String) -> String {
        let parsed = parse(input)

        let result = (0...127).map { (row: Int) -> String in
            return Day10.part2(input: "\(parsed)-\(row)")
        }.map {
            $0.map { bitOnesIn(String($0)) }
        }.flatMap {
            $0
        }.reduce(0, +)

        return "\(result)"
    }

    static func part2(input: String) -> String {
        let parsed = parse("flqrgnkx")

//        let grid = (0...127).map { (row: Int) -> [Bool] in
//            let hash = Day10.part2(input: "\(parsed)-\(row)")
//            return hash.map { convertToBool(String($0)) }.flatMap { $0 }
//        }

        return ""
    }

    private static func bitOnesIn(_ string: String) -> Int {
        return convertToBool(string).map { $0 ? 1 : 0 }.reduce(0, +)
    }

    private static func convertToBool(_ string: String) -> [Bool] {
        let number = Int(string, radix: 16)!
        return [0b1000, 0b0100, 0b0010, 0b0001].map { number & $0 > 0 }
    }

    private static func parse(_ input: String) -> String {
        return input.components(separatedBy: .newlines).first!
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        if count < toLength {
            return String(repeatElement(character, count: toLength - count)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
