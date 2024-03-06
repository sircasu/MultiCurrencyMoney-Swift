//
//  Sum.swift
//  MultiCurrencyMoney
//
//  Created by Matteo Casu on 06/03/24.
//

import Foundation

class Sum: Expression {
    
    private (set) var augend: Expression
    private (set) var addend: Expression
    
    init(_ augend: Expression, _ addend: Expression) {
        self.augend = augend
        self.addend = addend
    }
    
    func reduce(_ bank: Bank, _ to: String) -> Money {
        
        let amount: Int = augend.reduce(bank, to).amount + addend.reduce(bank, to).amount
        return Money(amount, to)
    }
    
    func plus(_ addend: Expression) -> Expression {
        Sum(self, addend)
    }
    
    func times(_ multiplier: Int) -> Expression {
        Sum(augend.times(multiplier), addend.times(multiplier))
    }
}

