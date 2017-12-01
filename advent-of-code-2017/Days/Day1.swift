//
//  Day1.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 01/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day1: Day {
    static func part1(input: String) -> String {
        let captcha = "\(input)\(input.prefix(1))".map { Int(String($0)) }.flatMap { $0 }

        let result = captcha.reduce((0, nil)) { (acc: (Int, Int?), char: Int) in
            (acc.0 + (acc.1 == char ? char : 0), char)
        }

        return "\(result.0)"
    }

    static func part2(input: String) -> String {
        let captcha = "\(input)\(input.prefix(1))".map { Int(String($0)) }.flatMap { $0 }
        let halfLength = captcha.count / 2

        let result = captcha.enumerated().reduce(0) { (result, enumeratedTuple) in
            let offset = enumeratedTuple.offset
            let element = enumeratedTuple.element
            let compareOffset = offset < halfLength ? offset + halfLength : offset - halfLength
            return result + (element == captcha[compareOffset] ? element : 0)
        }

        return "\(result)"
    }
}
