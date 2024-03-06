//
//  Pair.swift
//  MultiCurrencyMoney
//
//  Created by Matteo Casu on 06/03/24.
//

import Foundation

class Pair: Equatable, Hashable {

    
    private (set) var from: String
    private (set) var to: String
    
    init(_ from: String, _ to: String) {
        self.from = from
        self.to = to
    }
    
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        lhs.from == rhs.from
        && lhs.to == rhs.to
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
    }
}
