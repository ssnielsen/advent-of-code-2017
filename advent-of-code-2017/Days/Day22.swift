//
//  Day22.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 25/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day22: Day {
    static func part1(input: String) -> String {
        let infected = parse(input)
        let carrier = findStartPoint(in: input)
        let direction = Direction.north

        let result = (0..<10_000).reduce((infected: infected, carrier: carrier, direction: direction, infectionBursts: 0)) { state, _ in
            let next = burst(carrierPosition: state.carrier, infected: state.infected, direction: state.direction)
            return (next.infected, next.carrier, next.direction, state.infectionBursts + (next.infectedInBurst ? 1 : 0))
        }

        return "\(result.infectionBursts)"
    }

    static func part2(input: String) -> String {
        let infected = parse(input).map { ($0, NodeState.infected) }
        let infectedAdvanced = Dictionary(tuples: infected)
        let carrier = findStartPoint(in: input)
        let direction = Direction.north

        let result = (0..<10_000_000).reduce((infected: infectedAdvanced, carrier: carrier, direction: direction, infectionBursts: 0)) { state, _ in
            let next = burst2(carrierPosition: state.carrier, infected: state.infected, direction: state.direction)
            return (next.infected, next.carrier, next.direction, state.infectionBursts + (next.infectedInBurst ? 1 : 0))
        }

        return "\(result.infectionBursts)"
    }

    private static func burst(carrierPosition: Position, infected: Set<Position>, direction: Direction) -> (carrier: Position, infected: Set<Position>, direction: Direction, infectedInBurst: Bool) {
        let isCarrierPositionInfected = infected.contains(carrierPosition)
        let newDirection = direction.turn(isCarrierPositionInfected ? .right : .left)
        let newInfected = isCarrierPositionInfected ? infected.subtracting([carrierPosition]) : infected.union([carrierPosition])
        let moveVector = newDirection.moveVector
        let newCarrierPosition = Position(x: carrierPosition.x + moveVector.x, y: carrierPosition.y + moveVector.y)

        return (newCarrierPosition, newInfected, newDirection, !isCarrierPositionInfected)
    }

    private static func burst2(carrierPosition: Position, infected: [Position: NodeState], direction: Direction) -> (carrier: Position, infected: [Position: NodeState], direction: Direction, infectedInBurst: Bool) {

        let carrierPositionState = infected[carrierPosition] ?? .clean
        var turnings = [Turn]()
        switch carrierPositionState {
        case .clean:
            turnings.append(.left)
        case .weakened:
            break
        case .infected:
            turnings.append(.right)
        case .flagged:
            // Rotate 180 degrees
            turnings.append(.left)
            turnings.append(.left)
        }

        let newDirection = turnings.reduce(direction) { $0.turn($1) }
        var newInfected = infected
        newInfected[carrierPosition] = carrierPositionState.nextState()
        let moveVector = newDirection.moveVector
        let newCarrierPosition = Position(x: carrierPosition.x + moveVector.x, y: carrierPosition.y + moveVector.y)

        return (newCarrierPosition, newInfected, newDirection, carrierPositionState.nextState() == .infected)
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
        case north, east, south, west

        func turn(_ turn: Turn) -> Direction {
            switch (self, turn) {
            case (.north, .left):
                return .west
            case (.north, .right):
                return .east
            case (.east, .left):
                return .north
            case (.east, .right):
                return .south
            case (.south, .left):
                return .east
            case (.south, .right):
                return .west
            case (.west, .left):
                return .south
            case (.west, .right):
                return .north
            }
        }

        var moveVector: Position {
            switch self {
            case .north:
                return Position(x: 0, y: -1)
            case .east:
                return Position(x: 1, y: 0)
            case .south:
                return Position(x: 0, y: 1)
            case .west:
                return Position(x: -1, y: 0)
            }
        }

        var description: String {
            switch self {
            case .north: return "Up"
            case .east: return "Right"
            case .south: return "Down"
            case .west: return "Left"
            }
        }
    }

    enum NodeState {
        case weakened, infected, flagged, clean

        func nextState() -> NodeState {
            switch self {
            case .weakened:
                return .infected
            case .infected:
                return .flagged
            case .flagged:
                return .clean
            case .clean:
                return .weakened
            }
        }
    }
}
