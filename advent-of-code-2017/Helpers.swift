//
//  Helpers.swift
//  advent-of-code-2017
//
//  Created by Soren Sonderby Nielsen on 13/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

extension Dictionary {
    init(tuples: [(Key, Value)]) {
        self = tuples.reduce([Key: Value]()) {
            var dict = $0
            dict[$1.0] = $1.1
            return dict
        }
    }
}

extension Array where Element == String {
    func nonEmptyLines() -> [String] {
        return filter { !$0.isEmpty }
    }
}
