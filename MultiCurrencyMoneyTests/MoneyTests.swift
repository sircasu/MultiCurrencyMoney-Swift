//
//  MoneyTests.swift
//  MoneyTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
import MultiCurrencyMoney

// MARK: Money

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


// MARK: Expression

protocol Expression {
    func reduce(_ bank: Bank, _ to: String) -> Money
}


// MARK: Bank

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


// MARK: Sum

class Sum: Expression {
    
    private (set) var augend: Money
    private (set) var addend: Money
    
    init(_ augend: Money, _ addend: Money) {
        self.augend = augend
        self.addend = addend
    }
    
    func reduce(_ bank: Bank, _ to: String) -> Money {
        
        let amount: Int = augend.amount + addend.amount
        return Money(amount, to)
    }
}


// MARK: pair

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
    
    
    func testReduceMoneyDifferentCurrency() {
        
        let bank = Bank()
        bank.addRate("CHF", "USD", 2)
        let result: Money = bank.reduce(Money.franc(2), "USD")
        XCTAssertEqual(Money.dollar(1), result)
    }
    
    
    func testIdentifyRate() {
        XCTAssertEqual(1, Bank().rate("USD", "USD"))
    }
}
