//
//  Day3.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 03/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day3: Day {
    static func part1(input: String) -> String {
        let number = parse(input)

        let root = Int(ceil(sqrt(Double(number))))
        let curR = root % 2 != 0 ? root : root + 1
        let numR = (curR - 1) / 2
        let cycle = number - Int(pow(Double(curR - 2), 2))
        let innerOffset = cycle % (curR - 1)

        return String(numR + (abs(innerOffset - numR)))
    }

    static func part2(input: String) -> String {
        let number = parse(input)
        var system = Part2System()

        var pointValue: Int

        repeat {
            pointValue = system.next()
        } while number > pointValue

        return String(pointValue)
    }

    struct Part2System {
        typealias Point = (x: Int, y: Int)

        var direction = Direction.right
        var points = [Int: [Int: Int]]()
        var position: Point

        init() {
            points[0] = [0: 1]
            position = (x: 0, y: 0)
        }

        mutating func next() -> Int {
            switch direction {
            case .right:
                position = (x: position.x + 1, y: position.y)
            case .up:
                position = (x: position.x, y: position.y + 1)
            case .left:
                position = (x: position.x - 1, y: position.y)
            case .down:
                position = (x: position.x, y: position.y - 1)
            }

            let nextPointValue = value(for: position)
            points[position.x, default: [:]][position.y] = nextPointValue

            // If we hit a corner, switch direction.
            // Lower right corner is a special case as we expand the spiral there.
            if direction == .right && abs(position.x)-1 == abs(position.y)
                || direction != .right && abs(position.x) == abs(position.y) {
                direction.rotate()
            }

            return nextPointValue
        }

        private func value(for point: Point) -> Int {
            return Part2System.neighbors(for: point).reduce(0) { (sum, neighbor) in
                sum + (points[neighbor.x]?[neighbor.y] ?? 0)
            }
        }

        static func neighbors(for point: Point) -> [Point] {
            let template = [
                (x: -1, y:  1), (x: 0, y:  1), (x: 1, y:  1),
                (x: -1, y:  0),                (x: 1, y:  0),
                (x: -1, y: -1), (x: 0, y: -1), (x: 1, y: -1)
            ]

            return template.map {
                (x: point.x + $0.x, y: point.y + $0.y)
            }
        }

        enum Direction {
            case right, up, left, down

             mutating func rotate() {
                switch self {
                case .right: self = .up
                case .up: self = .left
                case .left: self = .down
                case .down: self = .right
                }
            }
        }
    }

    private static func parse(_ input: String) -> Int {
        return Int(input.components(separatedBy: .newlines).first!)!
    }
}
