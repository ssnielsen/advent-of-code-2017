//
//  Day7.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 07/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day7: Day {
    static func part1(input: String) -> String {
        let programs = parse(input)

        let programNames = Set(programs.keys)
        let mentionedNeighbors = Set(programs.values.map { $0.0 }.flatMap { $0 })
        let top = programNames.symmetricDifference(mentionedNeighbors)

        return top.first!
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func parse(_ input: String) -> [String: ([String], Int)] {
        var programs = [String: ([String], Int)]()

        input.nonEmptyLines().forEach {
            let parts = $0.components(separatedBy: " -> ")
            let program = parts.first!.components(separatedBy: .whitespaces)
            let name = program.first!
            let weight = Int(program.last!.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))!
            let programNeighbors = parts.count == 2 ? (parts.last?.components(separatedBy: ", ") ?? []) : []
            programs[name] = (programNeighbors, weight)
        }

        return programs
    }
}
