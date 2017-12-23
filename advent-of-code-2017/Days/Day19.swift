//
//  Day19.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 22/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

fileprivate extension Dictionary where Key == Int, Value == [Int: Character] {
    subscript(point point: Day19.Point) -> Character? {
        get {
            return self[point.x]?[point.y]
        }
    }
}

func ==(lhs: Day19.Point, rhs: Day19.Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

struct Day19: Day {
    typealias Point = (x: Int, y: Int)
    typealias Grid = [Int: [Int: Character]]

    static func part1(input: String) -> String {
        let grid = parse(input)
        let start = startingPoint(in: grid)

        return route(in: grid, from: start, visitedPackages: "").components(separatedBy: .init(charactersIn: "+|-")).joined()
    }

    static func part2(input: String) -> String {
        let grid = parse(input)
        let start = startingPoint(in: grid)

        return "\(route(in: grid, from: start, visitedPackages: "").count + 1)"
    }

    private static func startingPoint(in grid: Grid) -> Point {
        return (x: 0, y: grid[0]!.first(where: { $0.value == "|" })!.key)
    }

    private static func route(in grid: Grid, from point: Point, comingFrom pointBefore: Point = (x: -1, y: -1), visitedPackages: String) -> String {
        guard let next = step(from: point, comingFrom: pointBefore, in: grid) else {
            return visitedPackages
        }

        let letter = String(grid[point: next]!)
        return route(in: grid, from: next, comingFrom: point, visitedPackages: visitedPackages + letter)
    }

    private static func step(from point: Point, comingFrom pointBefore: Point, in grid: Grid) -> Point? {
        let letterBefore = grid[point: pointBefore] ?? "1"
        let letterCurrent = grid[point: point]!
        let neighbors = generateNeighbors(for: point)
        return neighbors.first {
            guard $0 != pointBefore, let letterNeighbor = grid[point: $0] else {
                return false
            }

            let onSameAxis = $0.x == pointBefore.x || $0.y == pointBefore.y

            switch (letterBefore, letterCurrent, letterNeighbor) {
            case (_, _, let letter) where ("A"..."Z").contains(String(letter)) && onSameAxis:
                return true
            case (_, "+", _):
                return true
            case (_, _, "+"):
                return true
            case (_, _, "-") where onSameAxis:
                return true
            case (_, _, "|") where onSameAxis:
                return true
            default:
                return false
            }
        }
    }

    private static func generateNeighbors(for point: Point) -> [Point] {
        let neighborMasks = [
            (x: -1, y:  0),
            (x:  0, y:  1),
            (x:  1, y:  0),
            (x:  0, y: -1)
        ]

        return neighborMasks.map { (x: point.x + $0.x, y: point.y + $0.y) }
    }

    private static func parse(_ input: String) -> Grid {
        let lines = input.components(separatedBy: .newlines).nonEmptyLines()

        var grid = Grid()

        lines.enumerated().forEach { x, line in
            line.enumerated().forEach { y, letter in
                if letter != " " {
                    grid[x, default: [:]][y] = letter
                }
            }
        }

        return grid
    }
}
