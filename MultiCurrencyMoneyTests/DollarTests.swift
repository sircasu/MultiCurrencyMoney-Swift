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
        amount = 5 * 2
    }
}


final class DollarTests: XCTestCase {

    func test_multiplication() {
        let five = Dollar(5)
        five.times(2)
        XCTAssertEqual(five.amount, 10)
    }
}
