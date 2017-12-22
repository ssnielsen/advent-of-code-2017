//
//  Day19.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 22/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day19: Day {
    typealias Point = (x: Int, y: Int)
    typealias Grid = [Int: [Int: Character]]

    static func part1(input: String) -> String {
        let grid = parse(input)
        let startingPoint: Point = (x: 0, y: grid[0]!.first(where: { $0.value == "|" })!.key)

        return route(in: grid, from: startingPoint, visitedPackages: "")
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func route(in grid: Grid, from point: Point, comingFrom pointBefore: Point = (x: -1, y: -1), visitedPackages: String) -> String {
        guard let next = step(from: point, comingFrom: pointBefore, in: grid) else {
            return visitedPackages
        }
        print(point)
        let letter = String(grid[next.x]![next.y]!)

        if ("A"..."Z").contains(letter) {
            return route(in: grid, from: next, comingFrom: point, visitedPackages: visitedPackages + letter)
        } else {
            return route(in: grid, from: next, comingFrom: point, visitedPackages: visitedPackages)
        }
    }

    private static func step(from point: Point, comingFrom pointBefore: Point, in grid: Grid) -> Point? {
        let neighbors = generateNeighbors(for: point)
        let nonVisitedNeighbors = neighbors.filter { ($0.x >= 0 && $0.y >= 0) && ($0.x != pointBefore.x || $0.y != pointBefore.y) }

        return nonVisitedNeighbors.first {
            grid[$0.x]?[$0.y] != nil
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
