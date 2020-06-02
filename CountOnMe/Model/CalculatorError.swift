//
//  CalculatorError.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case cannotDivideByZero
    case cannotAddAMathOperator
    case cannotAddEqualitySign
    case cannotIdentifyOperator

    var title: String {
        switch self {
        case .cannotDivideByZero: return "You cannot divide per zero"
        case .cannotAddAMathOperator: return "You cannot add a math operator"
        case .cannotAddEqualitySign: return "You cannot add an equality sign"
        case .cannotIdentifyOperator: return "Operator cannot be identified"
        }
    }
}


