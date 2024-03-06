//
//  MoneyTests.swift
//  MoneyTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
import MultiCurrencyMoney

protocol MoneyProtocol {
    
    func times(_ multiplier :Int) -> Money
    func getCurrency() -> String
}

class Money: MoneyProtocol, ExpressionProtocol {


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
    
    func times(_ multiplier: Int) -> Money {
        return Money(amount * multiplier, currency)
    }
    
    func getCurrency() -> String { currency }
 
    func plus(_ addend: Money) -> ExpressionProtocol {
        Money(amount + addend.amount, currency)
    }

}

extension Money: Equatable {
    static func == (lhs: Money, rhs: Money) -> Bool {
        lhs.amount == rhs.amount && lhs.currency == rhs.currency
    }
}


protocol ExpressionProtocol {}


class Bank {
    
    func reduce(_ source: ExpressionProtocol, _ to: String) -> Money {
        return Money.dollar(10)
    }
}


final class MoneyTests: XCTestCase {

    func test_moneyMultiplication() {
        
        let five: Money = Money.dollar(5)
        
        XCTAssertEqual(Money.dollar(10), five.times(2))
        XCTAssertEqual(Money.dollar(15), five.times(3))

    }
    
    func test_currency() {
        
        XCTAssertEqual(Money.dollar(1).getCurrency(), "USD")
        XCTAssertEqual(Money.franc(1).getCurrency(), "CHF")
    }
    
    func test_equality() {
        
        XCTAssertEqual(Money.dollar(5), Money.dollar(5))
        XCTAssertNotEqual(Money.dollar(5), Money.dollar(6))
        XCTAssertNotEqual(Money.franc(5), Money.dollar(5))
    }
    
    
    func test_simpleAddition() {
        
        let five: Money = Money.dollar(5)
        let sum: ExpressionProtocol = five.plus(five)
        let bank = Bank()
        let reduced: Money = bank.reduce(sum, "USD")
        XCTAssertEqual(Money.dollar(10), reduced)
    }
    
}
