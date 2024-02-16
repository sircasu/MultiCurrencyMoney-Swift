//
//  DollarTests.swift
//  DollarTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
import MultiCurrencyMoney


class Dollar: Equatable {
    
    private var amount: Int
    
    init(_ amount: Int){
        self.amount = amount
    }
    
    func times(_ multiplier: Int) -> Int {
        return amount * multiplier
    }
    
    static func == (lhs: Dollar, rhs: Dollar) -> Bool {
        lhs.amount == rhs.amount
    }
}


final class DollarTests: XCTestCase {

    func test_multiplication() {
        
        let five = Dollar(5)
        
        let product = Dollar(five.times(2))
        
        XCTAssertEqual(product, Dollar(10))
        
        let product2 = Dollar(five.times(3))
        
        XCTAssertEqual(product2, Dollar(15))
    }
    
    func test_equality() {
        
        XCTAssertEqual(Dollar(5), Dollar(5))
        XCTAssertNotEqual(Dollar(5), Dollar(6))
    }
}
