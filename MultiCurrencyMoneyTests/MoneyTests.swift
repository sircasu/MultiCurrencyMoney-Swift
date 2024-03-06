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


// MARK: Expression

protocol Expression {
    func reduce(_ bank: Bank, _ to: String) -> Money
    func plus(_ addend: Expression) -> Expression
    func times(_ multiplier: Int) -> Expression
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
        
        XCTAssertEqual(Money.dollar(10), five.times(2) as! Money)
        XCTAssertEqual(Money.dollar(15), five.times(3) as! Money)

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
        XCTAssertEqual(five, sum.augend as! Money)
        XCTAssertEqual(five, sum.addend as! Money)
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
    
    
    func testMixedAddition() {
        
        let fiveBucks: Expression = Money.dollar(5)
        let tenFrancs: Expression = Money.franc(10)
        let bank = Bank()
        bank.addRate("CHF", "USD", 2)
        let result: Money = bank.reduce(fiveBucks.plus(tenFrancs), "USD")
        XCTAssertEqual(Money.dollar(10), result)
    }
    
    
    func testSumPlusMoney() {
        
        let fiveBucks: Expression = Money.dollar(5)
        let tenFrancs: Expression = Money.franc(10)
        let bank = Bank()
        bank.addRate("CHF", "USD", 2)
        let sum: Expression = Sum(fiveBucks, tenFrancs).plus(fiveBucks)
        let result: Money = bank.reduce(sum, "USD")
        XCTAssertEqual(Money.dollar(15), result)
    }
    
    
    
    func testSumTimes() {
        let fiveBucks: Expression = Money.dollar(5)
        let tenFrancs: Expression = Money.franc(10)
        let bank = Bank()
        bank.addRate("CHF", "USD", 2)
        let sum: Expression = Sum(fiveBucks, tenFrancs).times(2)
        let result: Money = bank.reduce(sum, "USD")
        XCTAssertEqual(Money.dollar(20), result)
    }
    
    func testPlusSameCurrencyReturnsMoney() {
        let sum: Expression = Money.dollar(1).plus(Money.dollar(1))
        XCTAssertTrue(type(of: sum) != Money.self)
    }
}
