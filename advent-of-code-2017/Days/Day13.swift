//
//  Day13.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 13/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day13: Day {
    static func part1(input: String) -> String {
        let layers = parse(input)

        let severity = (0...layers.keys.max()!).reduce(0) { $0 + (severityAtPosition(inFirewall: layers, atTime: $1) ?? 0) }

        return "\(severity)"
    }

    static func part2(input: String) -> String {
        let layers = parse(input)
        let max = layers.keys.max() ?? 0

        let safeDelay = (10...).first { delay in
            (0...max).index { time in
                severityAtPosition(inFirewall: layers, atTime: time, withDelay: delay) != nil
            } == nil
        }

        return "\(safeDelay!)"
    }

    private static func severityAtPosition(inFirewall firewall: [Int: Int], atTime time: Int, withDelay delay: Int = 0) -> Int? {
        if let layer = firewall[time], (time + delay) % (layer * 2 - 2) == 0 {
            return layer * time
        } else {
            return nil
        }
    }

    private static func parse(_ input: String) -> [Int: Int] {
        let parsed: [(Int, Int)] = input.components(separatedBy: .newlines).filter { !$0.isEmpty }.map {
            let layer = $0.components(separatedBy: ": ")
            return (Int(layer.first!)!, Int(layer.last!)!)
        }

        return Dictionary(tuples: parsed)
    }
}
