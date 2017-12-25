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
            let string = try String(contentsOfFile: path, encoding: .utf8)

            return string
        } catch {
            print(error)

            return ""
        }
    }
}

let input = Helper.readDay(22)
let day = Day22.self
print(day.part1(input: input))
print(day.part2(input: input))









import Foundation

//let input = """
//..#
//#..
//...
//"""

struct Position: Hashable {
    var x: Int
    var y: Int

    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class VirusCarrier {
    enum Direction: Int {
        case up = 0
        case right
        case down
        case left

        func turnLeft() -> Direction {
            return Direction(rawValue: (self.rawValue - 1 + 4) % 4)!
        }

        func turnRight() -> Direction {
            return Direction(rawValue: (self.rawValue + 1) % 4)!
        }

        func reverse() -> Direction {
            return Direction(rawValue: (self.rawValue + 2) % 4)!
        }

        var vector: (dx: Int, dy: Int) {
            switch self {
            case .up:
                return (0, -1)
            case .right:
                return (1, 0)
            case .down:
                return (0, 1)
            case .left:
                return (-1, 0)
            }
        }
    }

    var infected: [Position: Int]
    var position: Position
    var direction = Direction.up
    var numberOfInfections = 0

    init(infected: [Position: Int], startPosition: Position) {
        self.infected = infected
        self.position = startPosition
    }

    func burst() {
        if infected.keys.contains(position) {
            direction = direction.turnRight()
            infected.removeValue(forKey: position)
        }
        else {
            direction = direction.turnLeft()
            infected[position] = 2
            numberOfInfections += 1
        }
        position.x += direction.vector.dx
        position.y += direction.vector.dy
        print((position, direction))
    }

    func burst2() {
        if infected[position, default: 0] == 0 { // 0==clean
            direction = direction.turnLeft()
        }
        else if infected[position, default: 0] == 1 { // 1==Weakened
            numberOfInfections += 1
        }
        else if infected[position, default: 0] == 2 { // 2==Infected
            direction = direction.turnRight()
        }
        else { // 3==Flagged
            direction = direction.reverse()
        }

        infected[position] = (infected[position, default: 0] + 1) % 4
        position.x += direction.vector.dx
        position.y += direction.vector.dy
    }
}

let testInput = """
..#
#..
...
"""

// Parse input to Position values for each infected position
let lines = testInput
    .components(separatedBy: .newlines)

let initial = lines
    .enumerated()
    .reduce(into: [Position: Int]()) { (dict, line) in
        line.element
            .enumerated()
            .filter { $0.element == "#" }
            .map { Position(x: $0.offset, y:line.offset) }
            .forEach { dict[$0] = 2 } // infected gets value 2, so we can insert other states later (weakened becomes 1)
}

let x = lines.count / 2
let y = lines.count / 2

let carrier = VirusCarrier(infected: initial, startPosition: Position(x: x, y: y))
let numberOfBursts = 70
for _ in 0..<numberOfBursts {
    carrier.burst()
}
print("Part one: \(carrier.numberOfInfections)")

//    let carrier2 = VirusCarrier(infected: initial, startPosition: Position(x: x, y: y))
//    let numberOfBursts2 = 10000000
//    for _ in 0..<numberOfBursts2 {
//        carrier2.burst2()
//    }
//    print("Part two: \(carrier2.numberOfInfections)")




