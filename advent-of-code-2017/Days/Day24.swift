//
//  Day24.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 26/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day24: Day {
    static func part1(input: String) -> String {
        let input = input
        let (startNodes, identityComponents) = parse(input)
        let paths = startNodes.map {
            dfs(start: $0)
        }.flatMap { $0 }

        let appendingIdentityComponents = paths.map { path -> [Node] in
            let containsPortValues = path.map { $0.ports }.flatMap { $0 }
            let containingIdentities = identityComponents.filter { containsPortValues.contains($0.ports.first!) }
            return path + containingIdentities
        }

        let withStrengths = appendingIdentityComponents.map { ($0, $0.map { $0.strength }.reduce(0, +)) }
        let sorted = withStrengths.sorted { $0.1 < $1.1 }

        return "\(sorted.last!.1)"
    }

    static func part2(input: String) -> String {
        let input = input
        let (startNodes, identityComponents) = parse(input)
        let paths = startNodes.map {
            dfs(start: $0)
        }.flatMap { $0 }

        let appendingIdentityComponents = paths.map { path -> [Node] in
            let containsPortValues = path.map { $0.ports }.flatMap { $0 }
            let containingIdentities = identityComponents.filter { containsPortValues.contains($0.ports.first!) }
            return path + containingIdentities
        }

        let withLengths = appendingIdentityComponents.map { ($0, $0.count) }
        let sorted = withLengths.sorted { $0.1 < $1.1 }
        let longestLength = sorted.last!.1
        let longest = sorted.filter { $0.1 == longestLength }
        let withStrengths = longest.map { ($0.0, $0.0.map { $0.strength }.reduce(0, +)) }
        let sortedWithStrengths = withStrengths.sorted { $0.1 < $1.1 }

        return "\(sortedWithStrengths.last!.1)"
    }

    private static func dfs(start: Node, usingPort port: Int = 0, visited: Set<Node> = [], path: [Node] = []) -> [[Node]] {
        var visited = visited
        visited.insert(start)

        let otherPort = start.ports.filter { $0 != port }.first!
        let outgoing = start.outgoing[otherPort, default: []]

        let neighbors: Set<Node> = outgoing.subtracting(visited)

        if neighbors.isEmpty {
            return [Array(visited)]
        }
        
        var paths = [[Node]]()
        for neighbor in neighbors {
            let otherPaths = dfs(start: neighbor, usingPort: otherPort, visited: visited, path: path + [start])
            paths.append(contentsOf: otherPaths)
        }

        return paths
    }

    private static func parse(_ input: String) -> (startNodes: [Node], identityComponents: [Node]) {
        let components = input.nonEmptyLines().map(Node.init)
        let startNode = Node(name: "S")

        let identityComponents = components.filter { Set($0.ports).count == 1 }
        let differentComponents = components.filter { Set($0.ports).count > 1 }

        // 'ports' is sorted. Assumes that no 0/0 exists
        let zeroComponents = differentComponents.filter { $0.ports.first == 0 }
        let nonZeroComponents = differentComponents.filter { $0.ports.first != 0 }

        // Point from start node to 0/x nodes
        zeroComponents.forEach { from in
            startNode.outgoing[0, default: []].insert(from)

            // And from 0/x to compatible nodes
            let otherPort = from.ports.last!
            nonZeroComponents.filter { $0 !== from && $0.ports.contains(otherPort) }.forEach { to in
                from.outgoing[otherPort, default: []].insert(to)
            }
        }

        // Build rest of the edges. Point from nodes to other compatible nodes
        nonZeroComponents.forEach { from in
            from.ports.forEach { port in
                nonZeroComponents.filter { $0 !== from && $0.ports.contains(port) }.forEach { to in
                    from.outgoing[port, default: []].insert(to)
                }
            }
        }

        return (zeroComponents, identityComponents)
    }

    class Node: Hashable, CustomStringConvertible {
        let name: String
        var outgoing = [Int: Set<Node>]()

        init(name: String) {
            self.name = name
        }

        lazy var ports: [Int] = {
            return name.components(separatedBy: "/").flatMap(Int.init).sorted()
        }()

        lazy var strength: Int = {
            return ports.reduce(0, +)
        }()

        var hashValue: Int {
            return name.hashValue
        }

        static func ==(lhs: Day24.Node, rhs: Day24.Node) -> Bool {
            return lhs.name == rhs.name
        }

        var description: String { return name }
    }
}
