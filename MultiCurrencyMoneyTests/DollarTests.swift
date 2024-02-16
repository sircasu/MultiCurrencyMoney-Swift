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
    
    func times(_ multiplier: Int) {
        amount *= multiplier
    }
}


final class DollarTests: XCTestCase {

    func test_multiplication() {
        
        let dollars = Dollar(5)
        
        dollars.times(2)
        
        XCTAssertEqual(dollars.amount, 10)
    }
}
