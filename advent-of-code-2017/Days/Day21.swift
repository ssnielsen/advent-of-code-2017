//
//  Day21.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 24/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day21: Day {
    static func part1(input: String) -> String {
        let rules = parse(input)
        let initial = Grid(".#./..#/###")

        let resultingGrid = (0..<5).reduce(initial) { grid, _ in
            grid.print()
            return iteration(over: grid, withRules: rules)
        }

        let enabledPixels = resultingGrid.grid
            .flatMap { $0 }
            .map { $0 ? 1 : 0 }
            .reduce(0, +)

        return "\(enabledPixels)"
    }

    static func part2(input: String) -> String {
        let rules = parse(input)
        let initial = Grid(".#./..#/###")

        let resultingGrid = (0..<18).reduce(initial) { grid, _ in
            grid.print()
            return iteration(over: grid, withRules: rules)
        }

        let enabledPixels = resultingGrid.grid
            .flatMap { $0 }
            .map { $0 ? 1 : 0 }
            .reduce(0, +)

        return "\(enabledPixels)"
    }

    private static func iteration(over grid: Grid, withRules rules: [Grid: Grid]) -> Grid {
        let tileSize = grid.size % 2 == 0 ? 2 : 3
        return tileAndReplace(in: grid, withRules: rules, tileSize: tileSize)
    }

    private static func tileAndReplace(in grid: Grid, withRules rules: [Grid: Grid], tileSize: Int) -> Grid {
        let tiled = tile(grid, size: tileSize)
        let replaced = replace(in: tiled, withRules: rules)
        let flattened = flatten(replaced, tileSize: tileSize + 1)
        return flattened
    }

    private static func replace(in grid: [[Grid]], withRules rules: [Grid: Grid]) -> [[Grid]] {
        return grid.map {
            $0.map { candidate in
                return rules[candidate] ?? candidate
            }
        }
    }

    private static func flatten(_ grid: [[Grid]], tileSize: Int) -> Grid {
        let newGridSize = grid.count*tileSize
        var newGrid = Array(repeating: Array(repeating: false, count: newGridSize), count: newGridSize)

        for i in 0..<(grid.count) {
            for j in 0..<(grid.count) {
                let tile = grid[i][j]
                for x in 0..<(tile.size) {
                    for y in 0..<(tile.grid[x].count) {
                        newGrid[i * tileSize + x][j * tileSize + y] = tile.grid[x][y]
                    }
                }
            }
        }

        return Grid(newGrid)
    }

    struct Grid {
        var grid: [[Bool]]

        init(_ string: String) {
            self.grid = string.components(separatedBy: "/").map {
                $0.map { $0 == "#" }
            }
        }

        init(_ grid: [[String]]) {
            self.grid = grid.map {
                $0.map { $0 == "#" }
            }
        }

        init(_ grid: [[Bool]]) {
            self.grid = grid
        }

        var size: Int {
            return grid.count
        }

        var inputFormat: String {
            return grid.map { $0.map { $0 ? "#" : "." }.joined() }.joined(separator: "/")
        }

        func print() {
            grid.forEach {
                let printable = $0.map { $0 ? "#" : "." }.joined()
                Swift.print(printable)
            }
        }
    }

    private static func parse(_ input: String) -> [Grid: Grid] {
        let tuples: [(Grid, Grid)] = input.nonEmptyLines().map { line -> [(Grid, Grid)] in
            let splitted = line.components(separatedBy: " => ")
            let base = splitted[0].components(separatedBy: "/").map { $0.map { String($0) } }
            let rot1 = base |> rotate
            let rot2 = rot1 |> rotate
            let rot3 = rot2 |> rotate
            let fHor = base |> flipHorizontal
            let fVer = base |> flipVertical
            let fHorRot1 = fHor |> rotate
            let fHorRot2 = fHorRot1 |> rotate
            let fHorRot3 = fHorRot2 |> rotate
            let result = Grid(splitted[1])

            return [
                (Grid(base), result),
                (Grid(rot1), result),
                (Grid(rot2), result),
                (Grid(rot3), result),
                (Grid(fHor), result),
                (Grid(fVer), result),
                (Grid(fHorRot1), result),
                (Grid(fHorRot2), result),
                (Grid(fHorRot3), result),
            ]
        }.flatMap { $0 }

        return Dictionary(tuples: tuples)
    }

    static func convertToString(_ grid: [[String]]) -> String {
        return grid.map { $0.joined() }.joined(separator: "/")
    }

    static func rotate<T>(_ grid: [[T]]) -> [[T]] {
        var grid = grid

        // Transpose (only works for square matrix)
        for i in 0..<(grid.count) {
            for j in i..<(grid[i].count) {
                let swapped = grid[i][j]
                grid[i][j] = grid[j][i]
                grid[j][i] = swapped
            }
        }

        // Reverse each row
        for i in 0..<grid.count {
            grid[i] = grid[i].reversed()
        }

        return grid
    }

    static func flipVertical<T>(_ grid: [[T]]) -> [[T]] {
        return grid.reversed()
    }

    static func flipHorizontal<T>(_ grid: [[T]]) -> [[T]] {
        return grid.map { $0.reversed() }
    }

    static func tile(_ grid: Grid, size: Int) -> [[Grid]] {
        let tiles = grid.size / size
        var tileGrid = [[Grid]]()

        for i in 0..<tiles {
            var grids = [Grid]()
            for j in 0..<tiles {
                var tile = Grid(Array(repeating: String(repeating: ".", count: size), count: size).joined(separator: "/"))
                for x in 0..<size {
                    for y in 0..<size {
                        tile.grid[x][y] = grid.grid[i*size + x][j*size + y]
                    }
                }
                grids.append(tile)
            }
            tileGrid.append(grids)
        }

        return tileGrid
    }
}

infix operator |> : MultiplicationPrecedence

func |> <T, U> (o: T, f: (T) -> U) -> U {
    return f(o)
}

infix operator |!> : MultiplicationPrecedence

func |!> <T, U> (o: T, f: (T) -> U?) -> U {
    return f(o)!
}

extension Day21.Grid: Hashable {
    var hashValue: Int {
        return inputFormat.hashValue
    }

    static func ==(lhs: Day21.Grid, rhs: Day21.Grid) -> Bool {
        return lhs.inputFormat == rhs.inputFormat
    }
}
