//
//  MoneyTests.swift
//  MoneyTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
import MultiCurrencyMoney


class Dollar: Equatable {
    
    private(set) var amount: Int
    
    init(_ amount: Int){
        self.amount = amount
    }
    
    func times(_ multiplier: Int) -> Dollar {
        return Dollar(amount * multiplier)
    }
    
    static func == (lhs: Dollar, rhs: Dollar) -> Bool {
        lhs.amount == rhs.amount
    }
}


class Franc: Equatable {
    
    private(set) var amount: Int
    
    init(_ amount: Int){
        self.amount = amount
    }
    
    func times(_ multiplier: Int) -> Franc {
        return Franc(amount * multiplier)
    }
    
    static func == (lhs: Franc, rhs: Franc) -> Bool {
        lhs.amount == rhs.amount
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
    }
}
