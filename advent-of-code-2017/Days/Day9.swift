//
//  Day9.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 09/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day9: Day {
    static func part1(input: String) -> String {
        let stream = parse(input)

        let result = compute(stream: stream)

        return "\(result.0)"
    }

    static func part2(input: String) -> String {
        let stream = parse(input)

        let result = compute(stream: stream)

        return "\(result.1)"
    }

    private static func parse(_ input: String) -> String {
        return input.components(separatedBy: .newlines).first!
    }

    private static func compute(stream: String) -> (Int, Int) {
        var depth = 0
        var score = 0
        var pointer = 0
        var garbage = false
        var removed = 0

        while (pointer < stream.count) {
            if garbage {
                removed += 1
            }

            switch stream[pointer] {
            case "{":
                if garbage {
                    break
                }
                depth += 1
            case "<":
                garbage = true
            case "!":
                if garbage {
                    removed -= 1 // '!' doesn't count against removed garbage counter
                    pointer += 1
                }
            case ">":
                removed -= 1
                garbage = false
            case "}":
                if garbage {
                    break
                }
                score += depth
                depth -= 1
            default:
                break
            }

            pointer += 1
        }

        return (score, removed)
    }
}

private extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
