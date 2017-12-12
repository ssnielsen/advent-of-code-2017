//
//  Day11.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 12/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day11: Day {
    static func part1(input: String) -> String {
        let directions = parse(input)

        let origin = Vector(x: 0, y: 0, z: 0)

        let finalPosition = directions.reduce(origin) { (vector, direction) in
            return vector + direction.move
        }

        return "\(finalPosition.distance)"
    }

    static func part2(input: String) -> String {
        let directions = parse(input)

        let origin = Vector(x: 0, y: 0, z: 0)

        let positions = directions.reduce(([origin])) { (history, direction) in
            return history + [history.last! + direction.move]
        }

        let distances = positions.map { $0.distance }

        return "\(distances.max()!)"
    }
    struct Vector {
        var x: Int
        var y: Int
        var z: Int

        var distance: Int {
            return max(abs(x), abs(y), abs(z))
        }
    }

    private static func parse(_ input: String) -> [Direction] {
        return input.components(separatedBy: .newlines).first!.components(separatedBy: ",").map { Direction(rawValue: $0)! }
    }

    enum Direction: String {
        case n, ne, se, s, sw, nw

        var move: Vector {
            switch self {
            case .n: return Vector(x: 1, y: 0, z: -1)
            case .ne: return Vector(x: 1, y: -1, z: 0)
            case .se: return Vector(x: 0, y: -1, z: 1)
            case .s: return Vector(x: -1, y: 0, z: 1)
            case .sw: return Vector(x: -1, y: 1, z: 0)
            case .nw: return Vector(x: 0, y: 1, z: -1)
            }
        }
    }
}

func + (lhs: Day11.Vector, rhs: Day11.Vector) -> Day11.Vector {
    return Day11.Vector(
        x: lhs.x + rhs.x,
        y: lhs.y + rhs.y,
        z: lhs.z + rhs.z
    )
}
