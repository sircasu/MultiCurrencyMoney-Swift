//
//  MoneyTests.swift
//  MoneyTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
import MultiCurrencyMoney


class Money: Equatable {
    
    private(set) var amount: Int
    
    init(amount: Int) {
        self.amount = amount
    }
    
    static func == (lhs: Money, rhs: Money) -> Bool {
        lhs.amount == rhs.amount && type(of: lhs) == type(of: rhs)
    }
}

class Dollar: Money {

    init(_ amount: Int){
        super.init(amount: amount)
    }
    
    func times(_ multiplier: Int) -> Dollar {
        return Dollar(amount * multiplier)
    }
}


class Franc: Money {
    
    init(_ amount: Int){
        super.init(amount: amount)
    }
    
    func times(_ multiplier: Int) -> Franc {
        return Franc(amount * multiplier)
    }
    
}


final class MoneyTests: XCTestCase {

    func test_dollarMultiplication() {
        
        let five = Dollar(5)
        
        XCTAssertEqual(Dollar(10), five.times(2))
        XCTAssertEqual(Dollar(15), five.times(3))

    }
    
    func test_francMultiplication() {
        
        let five = Franc(5)
        
        XCTAssertEqual(Franc(10), five.times(2))
        XCTAssertEqual(Franc(15), five.times(3))

    }
    
    func test_equality() {
        
        XCTAssertEqual(Dollar(5), Dollar(5))
        XCTAssertNotEqual(Dollar(5), Dollar(6))
        
        XCTAssertEqual(Franc(5), Franc(5))
        XCTAssertNotEqual(Franc(5), Franc(6))
        
        XCTAssertNotEqual(Franc(5), Dollar(5))
    }
}
