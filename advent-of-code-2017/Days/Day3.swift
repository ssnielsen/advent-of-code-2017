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
        return ""
    }

//    private static func distanceInSpiral(fromNumber number: Int) -> Int {
//        return 0
//    }
//
//    private static func closest(_ number: Int, inSequence sequence: [Int]) -> Int {
//        return sequence.reduce((closest: 1, diff: Int.max)) { (res, n) in
//            let testDiff = abs(n - number)
//            if testDiff < res.diff {
//                return (closest: n, diff: testDiff)
//            } else {
//                return res
//            }
//        }.closest
//    }
//
//    private static let oddSquares = {
//        return (1...1000).map { Int(pow(Double($0), 2)) }.filter { $0 % 2 != 0 }
//    }()

    private static func parse(_ input: String) -> Int {
        return Int(input.components(separatedBy: .newlines).first!)!
    }
}
