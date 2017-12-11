//
//  Day10.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 11/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day10: Day {
    static func part1(input: String) -> String {
        let lengths = parse(input)
        let initial = Array(0...255)

        let result = lengths.reduce((hash: initial, position: 0, skipSize: 0)) { result, length in
            return tieKnot(onHash: result.hash,
                           inPosition: result.position,
                           withLength: length,
                           usingSkipSize: result.skipSize)
        }
        let hash = result.hash

        return "\(hash[0] * hash[1])"
    }

    static func part2(input: String) -> String {
        return ""
    }

    static func tieKnot<T>(onHash hash: [T],
                           inPosition position: Int,
                           withLength length: Int,
                           usingSkipSize skipSize: Int) -> (hash: [T], position: Int, skipSize: Int) {
        var newHash = hash
        newHash.reverse(startPosition: position, length: length)

        return (hash: newHash,
                position: (position + length + skipSize) % hash.count,
                skipSize: skipSize + 1)
    }

    private static func parse(_ input: String) -> [Int] {
        return input.components(separatedBy: .newlines).first!.components(separatedBy: ",").flatMap(Int.init)
    }
}

fileprivate extension Array {
    mutating func reverse(startPosition: Int, length: Int) {
        var startPointer = startPosition % count
        var endPointer = (startPosition + length - 1) % count

        for _ in 0..<(length / 2) {
            // Swap elements
            let temp = self[startPointer]
            self[startPointer] = self[endPointer]
            self[endPointer] = temp

            // Increment / decrement pointers
            startPointer += 1
            endPointer -= 1

            // Check if we need to wrap around
            if (startPointer == count) {
                startPointer = 0
            }
            if (endPointer < 0) {
                endPointer = count - 1
            }
        }
    }
}
