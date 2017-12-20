//
//  main.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 01/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

protocol Day {
    static func part1(input: String) -> String
    static func part2(input: String) -> String
}

struct Helper {
    static func readDay(_ dayNumber: Int) -> String {
        let path = "\(FileManager.default.currentDirectoryPath)/Input/\(dayNumber)"

        do {
            let string = try String(contentsOfFile: path)

            return string
        } catch {
            print(error)

            return ""
        }
    }
}

let input = Helper.readDay(16)
let day = Day16.self
print(day.part1(input: input))
print(day.part2(input: input))
