//
//  Day5.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 05/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day5: Day {
    static func part1(input: String) -> String {
        let offsets = parse(input)
        let steps = compute(offsets, withOffsetRule: { _ in 1 })

        return String(steps)
    }

    static func part2(input: String) -> String {
        let offsets = parse(input)
        let steps = compute(offsets, withOffsetRule: { $0 >= 3 ? -1 : 1 })

        return String(steps)
    }

    private static func compute(_ offsets: [Int], withOffsetRule offsetRule: (Int) -> Int) -> Int {
        var index = 0
        var steps = 0
        var offsets = offsets

        repeat {
            let offset = offsets[index]
            offsets[index] += offsetRule(offset)
            index += offset
            steps += 1
        } while (0..<offsets.count).contains(index)

        return steps
    }

    private static func parse(_ input: String) -> [Int] {
        return input.nonEmptyLines().map { Int($0)! }
    }
}
