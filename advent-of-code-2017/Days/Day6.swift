//
//  Day6.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 06/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day6: Day {
    static func part1(input: String) -> String {
        let banks = parse(input)
        let cycles = compute(withInitialMemory: banks)
        return "\(cycles.count)"
    }

    static func part2(input: String) -> String {
        let banks = parse(input)
        let cycles = compute(withInitialMemory: banks)

        // Recalculate last distribution and find it's first occurrence
        let firstSameState = redistribute(cycles.last!)
        let firstSeen = cycles.index(where: { $0 == firstSameState })

        return "\(cycles.count - firstSeen!)"
    }

    private static func compute(withInitialMemory banks: [Int]) -> [[Int]] {
        return loop(banks: banks, history: [banks])
    }

    private static func loop(banks: [Int], history: [[Int]]) -> [[Int]] {
        let newBanks = redistribute(banks)

        // If we have seen the new distribution before return the history - otherwise continue.
        if history.contains(where: { $0 == newBanks }) {
            return history
        } else {
            return loop(banks: newBanks, history: history + [newBanks])
        }
    }

    private static func redistribute(_ banks: [Int]) -> [Int] {
        var nextBanks = banks

        // Find bank with the most blocks
        let max = banks.enumerated().reduce((offset: 0, element: Int.min)) { result, value in
            result.element < value.element ? value : result
        }

        // Reset found bank
        nextBanks[max.offset] = 0

        let startOffset = max.offset
        let blocks = max.element

        // Increment continuously
        (0..<blocks).forEach {
            let bank = (startOffset + 1 + $0) % nextBanks.count
            nextBanks[bank] += 1
        }

        return nextBanks
    }

    private static func parse(_ input: String) -> [Int] {
        return input.trimmingCharacters(in: .newlines).components(separatedBy: "    ").map { Int($0)! }
    }
}
