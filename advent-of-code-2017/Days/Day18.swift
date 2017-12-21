//
//  Day18.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 21/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

fileprivate extension Dictionary where Key == String, Value == Int {
    subscript(value: Day18.Value) -> Int {
        get {
            switch value {
            case let .register(register):
                return self[register] ?? 0
            case let .value(value):
                return value
            }
        }
    }
}

struct Day18: Day {
    typealias Registers = [String: Int]

    static let lastSoundRegister = "last_sound"
    static let recoveredSoundRegister = "recovered_sound"

    static func part1(input: String) -> String {
        let instructions = parse(input)
        var registers = Registers()
        var position = 0

        var recoveredSoundValue: Int? = nil

        repeat {
            (registers, position) = step(instructions[position], with: registers, position: position)
            recoveredSoundValue = registers[recoveredSoundRegister]
        } while recoveredSoundValue == nil

        return "\(recoveredSoundValue!)"
    }

    static func part2(input: String) -> String {
        return ""
    }

    private static func step(_ instruction: Instruction, with registers: Registers, position: Int) -> (registers: Registers, position: Int) {
        var registers = registers
        var nextPosition = position + 1

        switch instruction {
        case let .snd(register):
            registers[lastSoundRegister] = registers[.register(register)]
        case let .set(register, value):
            registers[register] = registers[value]
        case let .add(register, value):
            registers[register] = registers[.register(register)] + registers[value]
        case let .mul(register, value):
            registers[register] = registers[.register(register)] * registers[value]
        case let .mod(register, value):
            registers[register] = registers[.register(register)] % registers[value]
        case let .rcv(register):
            if registers[.register(register)] > 0 {
                registers[recoveredSoundRegister] = registers[lastSoundRegister]
            }
        case let .jgz(v1, v2):
            if registers[v1] > 0 {
                nextPosition = position + registers[v2]
            }
        }

        return (registers: registers, position: nextPosition)
    }

    private static func parse(_ input: String) -> [Instruction] {
        return input.components(separatedBy: .newlines).nonEmptyLines().map(Instruction.init)
    }

    enum Value {
        case register(String)
        case value(Int)

        init(_ input: String) {
            if let number = Int(input) {
                self = .value(number)
            } else {
                self = .register(input)
            }
        }
    }

    enum Instruction {
        case snd(String)
        case set(String, Value)
        case add(String, Value)
        case mul(String, Value)
        case mod(String, Value)
        case rcv(String)
        case jgz(Value, Value)

        init(_ input: String) {
            let tokens = input.components(separatedBy: .whitespaces)

            switch tokens[0] {
            case "snd":
                self = .snd(tokens[1])
            case "set":
                self = .set(tokens[1], Value(tokens[2]))
            case "add":
                self = .add(tokens[1], Value(tokens[2]))
            case "mul":
                self = .mul(tokens[1], Value(tokens[2]))
            case "mod":
                self = .mod(tokens[1], Value(tokens[2]))
            case "rcv":
                self = .rcv(tokens[1])
            case "jgz":
                self = .jgz(Value(tokens[1]), Value(tokens[2]))
            default:
                fatalError("\(input) is not valid input")
            }
        }
    }
}
