//
//  DollarTests.swift
//  DollarTests
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


final class DollarTests: XCTestCase {

    func test_multiplication() {
        
        let five = Dollar(5)
        
        XCTAssertEqual(Dollar(10), five.times(2))
        XCTAssertEqual(Dollar(15), five.times(3))

    }
    
    func test_equality() {
        
        XCTAssertEqual(Dollar(5), Dollar(5))
        XCTAssertNotEqual(Dollar(5), Dollar(6))
    }
}
