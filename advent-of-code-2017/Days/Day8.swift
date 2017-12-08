//
//  Day8.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 08/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day8: Day {
    static func part1(input: String) -> String {
        let instructions = parse(input)
        var machine = Machine(registers: [:])

        instructions.forEach {
            machine.process(instruction: $0)
        }

        let largestValue = machine.registers.values.sorted().last!

        return "\(largestValue)"
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func parse(_ input: String) -> [Instruction] {
        return input.components(separatedBy: .newlines).filter { !$0.isEmpty }.map(parseLine)
    }

    private static func parseLine(_ line: String) -> Instruction {
        let elements = line.components(separatedBy: .whitespaces)
        let actionValue = Int(elements[2])!

        return Instruction(register: elements[0],
                           action: Action(elements[1], value: actionValue),
                           op: Operator(elements[5]),
                           registerOprand: elements[4],
                           valueOperand: Int(elements[6])!)
    }

    struct Machine {
        var registers: [String: Int]

        mutating func process(instruction: Instruction) {
            let registerOperandValue = registers[instruction.registerOprand] ?? 0

            if instruction.op.function(registerOperandValue, instruction.valueOperand) {
                switch instruction.action {
                case let .inc(value):
                    registers[instruction.register, default: 0] += value
                case let .dec(value):
                    registers[instruction.register, default: 0] -= value
                }
            }
        }
    }

    struct Instruction {
        let register: String
        let action: Action
        let op: Operator
        let registerOprand: String
        let valueOperand: Int
    }

    enum Action {
        case inc(Int)
        case dec(Int)

        init(_ s: String, value: Int) {
            switch s {
            case "inc":
                self = .inc(value)
            case "dec":
                self = .dec(value)
            default:
                fatalError("\(s) is not a valid action")
            }
        }
    }

    enum Operator {
        case lt
        case le
        case gt
        case ge
        case eq
        case ne

        init(_ s: String) {
            switch s {
            case "<":
                self = .lt
            case "<=":
                self = .le
            case ">":
                self = .gt
            case ">=":
                self = .ge
            case "==":
                self = .eq
            case "!=":
                self = .ne
            default:
                fatalError("\(s) is not a valid operator")
            }
        }

        var function: (Int, Int) -> Bool {
            switch self {
            case .lt:
                return { $0 < $1 }
            case .le:
                return { $0 <= $1 }
            case .gt:
                return { $0 > $1 }
            case .ge:
                return { $0 >= $1 }
            case .eq:
                return { $0 == $1 }
            case .ne:
                return { $0 != $1 }
            }
        }
    }
}
