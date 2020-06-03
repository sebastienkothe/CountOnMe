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
    case cannotAddEqualSign

    var title: String {
        switch self {
        case .cannotDivideByZero: return "Cannot divide by zero"
        case .cannotAddAMathOperator: return "Cannot add an operator"
        case .cannotAddEqualSign: return "Cannot add an equal sign"
        }
    }
}


