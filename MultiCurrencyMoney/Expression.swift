//
//  Expression.swift
//  MultiCurrencyMoney
//
//  Created by Matteo Casu on 06/03/24.
//

import Foundation

protocol Expression {
    func reduce(_ bank: Bank, _ to: String) -> Money
    func plus(_ addend: Expression) -> Expression
    func times(_ multiplier: Int) -> Expression
}
