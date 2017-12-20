//
//  Day16.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 20/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day16: Day {
    static func part1(input: String) -> String {
        let moves = parse(input)

        let initial = Array("abcdefghijklmnop").map { String($0) }

        let result = moves.reduce(initial) { programs, move in
            execute(move, in: programs)
        }

        return String(result.joined())
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func execute(_ move: Move, in programs: [String]) -> [String] {
        switch move {
        case let .spin(times):
            let distance = programs.count - times
            return Array(programs[distance...]) + Array(programs[..<distance])

        case let .exchange(i, j):
            var afterExchange = programs
            afterExchange.swapAt(i, j)
            return afterExchange

        case let .partner(a, b):
            let indexOfA = programs.index(of: a)!
            let indexOfB = programs.index(of: b)!

            return execute(.exchange(indexOfA, indexOfB), in: programs)
        }
    }

    private static func parse(_ input: String) -> [Move] {
        return input.components(separatedBy: .newlines).first!.components(separatedBy: ",").map(Move.init)
    }

    enum Move {
        case spin(programs: Int)
        case exchange(Int, Int)
        case partner(String, String)

        init(_ input: String) {
            let data = input.dropFirst()

            switch input.prefix(1) {
            case "s":
                self = .spin(programs: Int(data)!)
            case "x":
                let positions = data.split(separator: "/")
                self = .exchange(Int(positions.first!)!, Int(positions.last!)!)
                break
            case "p":
                let positions = data.split(separator: "/")
                self = .partner(String(positions.first!), String(positions.last!))
                break
            default:
                fatalError("Unknown move: \(input)")
            }
        }
    }
}
