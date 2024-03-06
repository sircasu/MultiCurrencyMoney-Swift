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
    
    func times(_ multiplier: Int) -> Money {
        return Money(amount * multiplier, currency)
    }
    
    func getCurrency() -> String { currency }
 

    func plus(_ addend: Money) -> Expression {
        Sum(self, addend)
    }
    
    func reduce(_ to: String) -> Money {
        self
    }

}

extension Money: Equatable {
    static func == (lhs: Money, rhs: Money) -> Bool {
        lhs.amount == rhs.amount && lhs.currency == rhs.currency
    }
}


protocol Expression {
    func reduce(_ to: String) -> Money
}


class Bank {
    
    func reduce(_ source: Expression, _ to: String) -> Money {

        source.reduce(to)
    }
}


class Sum: Expression {
    
    private (set) var augend: Money
    private (set) var addend: Money
    
    init(_ augend: Money, _ addend: Money) {
        self.augend = augend
        self.addend = addend
    }
    
    func reduce(_ to: String) -> Money {
        
        let amount: Int = augend.amount + addend.amount
        return Money(amount, to)
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
        let sum: Expression = five.plus(five)
        let bank = Bank()
        let reduced: Money = bank.reduce(sum, "USD")
        XCTAssertEqual(Money.dollar(10), reduced)
    }
    
    
    func testPlusReturnsSum() {
        
        let five: Money = Money.dollar(5)
        let result: Expression = five.plus(five)
        let sum: Sum = result as! Sum
        XCTAssertEqual(five, sum.augend)
        XCTAssertEqual(five, sum.addend)
    }
    
    
    func testReduceSum() {
        
        let sum: Expression = Sum(Money.dollar(3), Money.dollar(4))
        let bank = Bank()
        let result: Money = bank.reduce(sum, "USD")
        XCTAssertEqual(Money.dollar(7), result)
    }
    
    
    func testReduceMoney() {
    
        let bank = Bank()
        let result: Money = bank.reduce(Money.dollar(1), "USD")
        XCTAssertEqual(Money.dollar(1), result)
    }
}
