//
//  Day22.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 25/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day22: Day {
    static let testInput = """
..#
#..
...
"""

    static func part1(input: String) -> String {
        let input = testInput
        let infected = parse(input)
        let carrier = findStartPoint(in: input)
        let direction = Direction.up

        let result = (0..<70).reduce((infected: infected, carrier: carrier, direction: direction, infectionBursts: 0)) { state, _ in
            print(state)
            let next = burst(carrierPosition: state.carrier, infected: state.infected, direction: state.direction)
            return (next.infected, next.carrier, next.direction, state.infectionBursts + (next.infectedInBurst ? 1 : 0))
        }

        return "\(result.infectionBursts)"
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func burst(carrierPosition: Position, infected: Set<Position>, direction: Direction) -> (carrier: Position, infected: Set<Position>, direction: Direction, infectedInBurst: Bool) {
        let isCarrierPositionInfected = infected.contains(carrierPosition)
        let newDirection = direction.turn(isCarrierPositionInfected ? .right : .left)
        let newInfected = isCarrierPositionInfected ? infected.subtracting([carrierPosition]) : infected.union([carrierPosition])
        let moveVector = newDirection.moveVector
        let newCarrierPosition = Position(x: carrierPosition.x + moveVector.x, y: carrierPosition.y + moveVector.y)
//        print((newCarrierPosition, newDirection))

        return (newCarrierPosition, newInfected, newDirection, !isCarrierPositionInfected)
    }

    private static func findStartPoint(in input: String) -> Position {
        let lines = input.nonEmptyLines()

        return Position(x: lines.count / 2, y: lines.first!.count / 2)
    }

    private static func parse(_ input: String) -> Set<Position> {
        var infected = Set<Position>()

        input.nonEmptyLines().enumerated().forEach { line in
            line.element.enumerated().forEach { char in
                if char.element == "#" {
                    infected.insert(Position(x: char.offset, y: line.offset))
                }
            }
        }

        return infected
    }

    struct Position: Hashable, CustomStringConvertible {
        let x: Int
        let y: Int

        var hashValue: Int {
            return x.hashValue ^ y.hashValue
        }

        static func == (lhs: Position, rhs: Position) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }

        var description: String {
            return "(\(x), \(y))"
        }
    }

    enum Turn {
        case left, right
    }

    enum Direction: CustomStringConvertible {
        case up, right, down, left

        func turn(_ turn: Turn) -> Direction {
            switch (self, turn) {
            case (.up, .left):
                return .left
            case (.up, .right):
                return .right
            case (.right, .left):
                return .up
            case (.right, .right):
                return .down
            case (.down, .left):
                return .right
            case (.down, .right):
                return .left
            case (.left, .left):
                return .down
            case (.left, .right):
                return .up
            }
        }

        var moveVector: Position {
            switch self {
            case .up:
                return Position(x: 0, y: 1)
            case .right:
                return Position(x: 1, y: 0)
            case .down:
                return Position(x: 0, y: -1)
            case .left:
                return Position(x: -1, y: 0)
            }
        }

        var description: String {
            switch self {
            case .up: return "Up"
            case .right: return "Right"
            case .down: return "Down"
            case .left: return "Left"
            }
        }
    }

}
