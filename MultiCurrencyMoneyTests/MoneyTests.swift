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

class Money: Equatable, MoneyProtocol {


    private(set) var amount: Int
    private(set) var currency: String
    
    init(_ amount: Int, _ currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    static func dollar(_ amount: Int) -> Dollar {
        return Dollar(amount, "USD")
    }
        
    static func franc(_ amount: Int) -> Franc {
        return Franc(amount, "CHF")
    }
    
    func times(_ multiplier: Int) -> Money {
        return Money(amount * multiplier, currency)
    }
    
    
    func getCurrency() -> String { currency }
 
    static func == (lhs: Money, rhs: Money) -> Bool {
        lhs.amount == rhs.amount && type(of: lhs) == type(of: rhs)
    }
}


class Dollar: Money {
    
    override func times(_ multiplier: Int) -> Money {
        return Dollar(amount * multiplier, currency)
    }
}



class Franc: Money {
    
    override func times(_ multiplier: Int) -> Money {
        return Franc(amount * multiplier, currency)
    }
}


final class MoneyTests: XCTestCase {

    func test_dollarMultiplication() {
        
        let five: Money = Money.dollar(5)
        
        XCTAssertEqual(Money.dollar(10), five.times(2))
        XCTAssertEqual(Money.dollar(15), five.times(3))

    }
    
    func test_francMultiplication() {
        
        let five: Money = Money.franc(5)
        
        XCTAssertEqual(Money.franc(10), five.times(2))
        XCTAssertEqual(Money.franc(15), five.times(3))

    }
    
    
    func test_currency() {
        
        XCTAssertEqual(Money.dollar(1).getCurrency(), "USD")
        XCTAssertEqual(Money.franc(1).getCurrency(), "CHF")
    }
    
    func test_equality() {
        
        XCTAssertEqual(Money.dollar(5), Money.dollar(5))
        XCTAssertNotEqual(Money.dollar(5), Money.dollar(6))
        
        XCTAssertEqual(Money.franc(5), Money.franc(5))
        XCTAssertNotEqual(Money.franc(5), Money.franc(6))
        
        XCTAssertNotEqual(Money.franc(5), Money.dollar(5))
    }
    
    
}
