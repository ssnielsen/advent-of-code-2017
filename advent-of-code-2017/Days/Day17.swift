//
//  Day17.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 21/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day17: Day {
    static func part1(input: String) -> String {
        let steps = parse(input)

        let result = (1...2017).reduce((buffer: [0], position: 0)) { state, iteration in
            let buffer = state.buffer
            let position = state.position
            let nextPosition = (position + 1 + steps) % buffer.count
            let firstPart = Array(buffer[...nextPosition])
            let newBuffer = firstPart + [iteration] + buffer[(nextPosition+1)...]
            return (buffer: newBuffer, position: nextPosition)
        }

        return "\(result.0[result.1+2])"
    }

    static func part2(input: String) -> String {
        let steps = parse(input)

        let result = (1...50_000_000).reduce((afterZero: nil as Int?, position: 0)) { state, iteration in
            let nextPosition = (state.position + 1 + steps) % iteration
            let afterZero = nextPosition == 0 ? iteration : state.afterZero
            return (afterZero: afterZero, position: nextPosition)
        }

        return "\(result.afterZero!)"
    }

    private static func parse(_ input: String) -> Int {
        return Int(input.replacingOccurrences(of: "\n", with: ""))!
    }
}
