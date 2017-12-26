//
//  Day23.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 26/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day23: Day {
    typealias Registers = [String: Int]

    static func part1(input: String) -> String {
        let instructions = parse(input)

        let mulInstructions = runPart1(instructions: instructions)

        return "\(mulInstructions)"
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func runPart1(instructions: [Instruction], position: Int = 0, registers: Registers = Registers(), mulInstructions: Int = 0) -> Int {
        if position >= instructions.count {
            return mulInstructions
        } else {
            let instruction = instructions[position]
            let (newRegisters, newPosition) = perform(instruction, withRegisters: registers, position: position)
            if case .mul = instruction {
                return runPart1(instructions: instructions, position: newPosition, registers: newRegisters, mulInstructions: mulInstructions + 1)
            } else {
                return runPart1(instructions: instructions, position: newPosition, registers: newRegisters, mulInstructions: mulInstructions)
            }
        }
    }

    private static func perform(_ instruction: Instruction, withRegisters registers: Registers, position: Int) -> (registers: Registers, position: Int) {
        var registers = registers

        switch instruction {
        case let .set(register, .int(number)):
            registers[register] = number
            return (registers, position + 1)
        case let .set(register, .reg(valueRegister)):
            registers[register] = registers[valueRegister, default: 0]
            return (registers, position + 1)
        case let .sub(register, .int(number)):
            registers[register] = registers[register, default: 0] - number
            return (registers, position + 1)
        case let .sub(register, .reg(valueRegister)):
            registers[register] = registers[register, default: 0] - registers[valueRegister, default: 0]
            return (registers, position + 1)
        case let .mul(register, .int(number)):
            registers[register] = registers[register, default: 0] * number
            return (registers, position + 1)
        case let .mul(register, .reg(valueRegister)):
            registers[register] = registers[register, default: 0] * registers[valueRegister, default: 0]
            return (registers, position + 1)
        case let .jnz(.int(number), posDelta):
            return (registers, number != 0 ? position + posDelta : position + 1)
        case let .jnz(.reg(register), posDelta):
            let number = registers[register, default: 0]
            return (registers, number != 0 ? position + posDelta : position + 1)
        }
    }

    private static func parse(_ input: String) -> [Instruction] {
        return input.nonEmptyLines().map(Instruction.init)
    }

    enum Value {
        case int(Int)
        case reg(String)

        init(_ string: String) {
            if let number = Int(string) {
                self = .int(number)
            } else {
                self = .reg(string)
            }
        }
    }

    enum Instruction {
        case set(String, Value)
        case sub(String, Value)
        case mul(String, Value)
        case jnz(Value, Int)

        init(_ string: String) {
            let splitted = string.components(separatedBy: .whitespaces)

            switch splitted[0] {
            case "set":
                self = .set(splitted[1], Value(splitted[2]))
            case "sub":
                self = .sub(splitted[1], Value(splitted[2]))
            case "mul":
                self = .mul(splitted[1], Value(splitted[2]))
            case "jnz":
                self = .jnz(Value(splitted[1]), Int(splitted[2])!)
            default:
                fatalError("\(string) not recognized as valid input")
            }
        }
    }
}
