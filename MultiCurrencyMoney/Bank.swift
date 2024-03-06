//
//  Bank.swift
//  MultiCurrencyMoney
//
//  Created by Matteo Casu on 06/03/24.
//

import Foundation

class Bank {
    
    private(set) var rates: [Pair: Int] = [:]
    
    func reduce(_ source: Expression, _ to: String) -> Money {

        source.reduce(self, to)
    }
    
    func rate(_ from: String, _ to: String) -> Int? {

        if from == to { return 1 }
        let rate = rates[Pair(from, to)]
        return rate
    }
    
    
    func addRate(_ from: String, _ to: String, _ rate: Int) {
        rates[Pair(from, to)] = rate
    }
}
