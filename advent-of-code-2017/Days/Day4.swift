//
//  Day4.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 04/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day4: Day {
    static func part1(input: String) -> String {
        let passwords = parse(input)

        let validPasswords = passwords.filter { $0.count == Set($0).count }

        return String(validPasswords.count)
    }

    static func part2(input: String) -> String {
        let passwords = parse(input)

        let sortedPasswords = passwords.map {
            $0.map {
                String($0.sorted())
            }
        }

        let validPasswords = sortedPasswords.filter { $0.count == Set($0).count }

        return String(validPasswords.count)
    }

    private static func parse(_ input: String) -> [[String]] {
        return input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: .whitespaces) }
    }
}
