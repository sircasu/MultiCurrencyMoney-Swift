//
//  MoneyTests.swift
//  MoneyTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
@testable import MultiCurrencyMoney

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
