//
//  Day2.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 03/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day2: Day {
    static func part1(input: String) -> String {
        let parsed = parse(input)

        let result = parsed.map(minMax).map { $0.max - $0.min }.reduce(0, +)

        return String(result)
    }

    static func part2(input: String) -> String {
        let parsed = parse(input)

        let result = parsed.map(evenDivisiblePairResult).reduce(0, +)

        return String(result)
    }

    private static func parse(_ input: String) -> [[Int]] {
        let lines = input.components(separatedBy: "\n")
        let splittedLines = lines.map {
            $0.components(separatedBy: "    ").map {
                Int($0)
            }.flatMap { $0 }
        }.filter { !$0.isEmpty }

        return splittedLines
    }

    private static func minMax(ofRow row: [Int]) -> (min: Int, max: Int) {
        return row.reduce((min: .max, max: .min), { (minMax, n) in
            return (min: min(minMax.min, n), max: max(minMax.max, n))
        })
    }

    private static func evenDivisiblePairResult(_ numbers: [Int]) -> Int {
        let pairs = product(ofList: numbers, andList: numbers)

        let divisiblePair = pairs.first { pair in
            return pair.0 != pair.1 && pair.0 % pair.1 == 0
        }

        guard divisiblePair != nil else {
            return 0
        }

        return divisiblePair!.0 / divisiblePair!.1
    }

    private static func product<T, U>(ofList listA: [T], andList listB: [U]) -> [(T, U)] {
        return listA.map { elemA in
            return listB.map { elemB in
                return (elemA, elemB)
            }
        }.flatMap { $0 }
    }
}
