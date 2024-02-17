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
    
    func currency() -> String
    
}

class Money: Equatable, MoneyProtocol {


    private(set) var amount: Int
    
    init(_ amount: Int) {
        self.amount = amount
    }
    
    static func dollar(_ amount: Int) -> Dollar {
        return Dollar(amount)
    }
        
    static func franc(_ amount: Int) -> Franc {
        return Franc(amount)
    }
    
    func times(_ multiplier: Int) -> Money {
        return Money(amount * multiplier)
    }
    
    
    func currency() -> String { "" }
 
    static func == (lhs: Money, rhs: Money) -> Bool {
        lhs.amount == rhs.amount && type(of: lhs) == type(of: rhs)
    }
}


class Dollar: Money {
    

    override func times(_ multiplier: Int) -> Money {
        return Dollar(amount * multiplier)
    }
    
    
    override func currency() -> String { "USD" }
}



class Franc: Money {
    
    override func times(_ multiplier: Int) -> Money {
        return Franc(amount * multiplier)
    }
    
    override func currency() -> String { "CHF" }
    
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
        
        XCTAssertEqual(Money.dollar(1).currency(), "USD")
        XCTAssertEqual(Money.franc(1).currency(), "CHF")
    }
    
    func test_equality() {
        
        XCTAssertEqual(Money.dollar(5), Money.dollar(5))
        XCTAssertNotEqual(Money.dollar(5), Money.dollar(6))
        
        XCTAssertEqual(Money.franc(5), Money.franc(5))
        XCTAssertNotEqual(Money.franc(5), Money.franc(6))
        
        XCTAssertNotEqual(Money.franc(5), Money.dollar(5))
    }
    
    
}
