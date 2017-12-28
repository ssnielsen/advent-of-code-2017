//
//  Day25.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 28/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day25: Day {
    typealias Tape = [Int: Int]
    typealias States = [String: State]

    static func part1(input: String) -> String {
        let (states, startState, steps) = parse(input)

        let result = (0..<steps).reduce((nextState: startState, tapePosition: 0, tape: Tape())) { state, step in
            let nextState = performStep(withState: state.nextState, states: states, tapePosition: state.tapePosition, tape: state.tape)
            return nextState
        }

        let ones = result.tape.values.filter { $0 == 1 }.count

        return "\(ones)"
    }

    static func part2(input: String) -> String {
        return "There is no part 2"
    }

    private static func performStep(withState state: String, states: States, tapePosition: Int, tape: Tape) -> (nextState: String, tapePosition: Int, tape: Tape) {
        var tape = tape

        let state = states[state]!
        let stateActions = tape[tapePosition, default: 0] == 1 ? state.oneActions : state.zeroActions
        tape[tapePosition] = stateActions.valueToWrite
        let nextTapePosition = tapePosition + stateActions.positionDelta

        return (stateActions.nextState, nextTapePosition, tape)
    }

    private static func parse(_ input: String) -> (states: States, startState: String, stepsToDiagnosticChecksum: Int) {
        let lines = input.nonEmptyLines()
        let startState = lines[0].suffix(2).prefix(1) |> String.init
        let steps = lines[1].components(separatedBy: .whitespaces)[5] |!> Int.init

        let stateLines = Array(lines.dropFirst(2)).chunked(by: 9)
        let states = stateLines.map { stateLines -> (String, State) in
            let name = stateLines[0].suffix(2).prefix(1) |> String.init
            let stateActionLines = Array(stateLines.dropFirst()).chunked(by: 4)
            let stateActions = stateActionLines.map { stateAction -> StateActions in
                let valueToWrite = stateAction[1].suffix(2).prefix(1) |> String.init |!> Int.init
                let positionDelta = stateAction[2].components(separatedBy: .whitespaces).last!.replacingOccurrences(of: ".", with: "") == "right" ? 1 : -1
                let nextState = stateAction[3].suffix(2).prefix(1) |> String.init
                return StateActions(valueToWrite: valueToWrite, positionDelta: positionDelta, nextState: nextState)
            }
            return (name, State(zeroActions: stateActions[0], oneActions: stateActions[1]))
        }

        return (Dictionary(tuples: states), startState, steps)
    }

    struct State {
        let zeroActions: StateActions
        let oneActions: StateActions
    }

    struct StateActions {
        let valueToWrite: Int
        let positionDelta: Int
        let nextState: String
    }
}
