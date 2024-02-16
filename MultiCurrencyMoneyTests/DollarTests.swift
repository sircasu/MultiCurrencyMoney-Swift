//
//  DollarTests.swift
//  DollarTests
//
//  Created by Matteo Casu on 15/02/24.
//

import XCTest
import MultiCurrencyMoney


class Dollar {
    var amount: Int
    
    init(_ amount: Int){
        self.amount = amount
    }
    
    func times(_ multiplier: Int) -> Int {
        return amount * multiplier
    }
}


final class DollarTests: XCTestCase {

    func test_multiplication() {
        
        let five = Dollar(5)
        
        let productAmount1 = five.times(2)
        
        XCTAssertEqual(productAmount1, 10)
        
        let productAmount2 = five.times(3)
        
        XCTAssertEqual(productAmount2, 15)
    }
}
