//
//  Money.swift
//  MultiCurrencyMoney
//
//  Created by Matteo Casu on 06/03/24.
//

import Foundation

protocol MoneyProtocol {
    
    func getCurrency() -> String
}

class Money: MoneyProtocol, Expression {


    private(set) var amount: Int
    private(set) var currency: String
    
    init(_ amount: Int, _ currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    static func dollar(_ amount: Int) -> Money {
        return Money(amount, "USD")
    }
        
    static func franc(_ amount: Int) -> Money {
        return Money(amount, "CHF")
    }
    
    func times(_ multiplier: Int) -> Expression {
        return Money(amount * multiplier, currency)
    }
    
    func getCurrency() -> String { currency }
 

    func plus(_ addend: Expression) -> Expression {
        Sum(self, addend)
    }
    
    func reduce(_ bank: Bank, _ to: String) -> Money {
    
        let rate: Int = bank.rate(currency, to) ?? 1
        return Money(amount / rate, to)
    }

}

extension Money: Equatable {
    static func == (lhs: Money, rhs: Money) -> Bool {
        lhs.amount == rhs.amount && lhs.currency == rhs.currency
    }
}
