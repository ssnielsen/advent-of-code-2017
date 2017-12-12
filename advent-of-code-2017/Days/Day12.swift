//
//  Day12.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 12/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day12: Day {
    typealias Graph = [Int: [Int]]

    static func part1(input: String) -> String {
        let graph = parse(input)

        let reachbleFromZero = reachableFrom(0, graph: graph, whenIgnoring: [])

        return "\(reachbleFromZero.count)"
    }

    static func part2(input: String) -> String {
        let graph = parse(input)

        let allPrograms = Set(0..<graph.keys.count)
        var groups = [Set<Int>]()

        while allPrograms != groups.reduce(Set<Int>(), { $0.union($1) }) {
            let candidates = groups.reduce(allPrograms) { $0.subtracting($1) }
            let origin = candidates.first!

            let reachableFromOrigin = reachableFrom(origin,
                                                    graph: graph,
                                                    whenIgnoring: Array(groups.reduce(Set<Int>(), { $0.union($1) })))

            if reachableFromOrigin.isEmpty {
                groups.append([origin])
            } else {
                groups.append(reachableFromOrigin)
            }
        }

        return "\(groups.count)"
    }

    private static func reachableFrom(_ program: Int, graph: Graph, whenIgnoring ignored: [Int]) -> Set<Int> {
        let neighbors = graph[program] ?? []

        let subsequentNeighbors = neighbors.map {
            return !ignored.contains($0) ? reachableFrom($0, graph: graph, whenIgnoring: ignored + neighbors) : []
        }.flatMap { $0 }

        return Set(neighbors + subsequentNeighbors)
    }

    private static func parse(_ input: String) -> Graph {
        let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }

        let programs = lines.map { (line: String) -> (Int, [Int]) in
            let programLine = line.components(separatedBy: " <-> ")
            let program = Int(programLine.first!)!
            let neighborPrograms = programLine.last!.components(separatedBy: ", ").map { Int($0)! }
            return (program, neighborPrograms)
        }

        return Dictionary(tuples: programs)
    }
}

fileprivate extension Dictionary {
    init(tuples: [(Key, Value)]) {
        self = tuples.reduce([Key: Value]()) {
            var dict = $0
            dict[$1.0] = $1.1
            return dict
        }
    }
}
