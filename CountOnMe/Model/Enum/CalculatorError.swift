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
    case cannotConvertMathOperatorFromTag
    
    var title: String {
        switch self {
        case .cannotDivideByZero: return "error_divide_by_zero_title".localized
        case .cannotAddAMathOperator: return "error_add_operator_title".localized
        case .cannotAddEqualSign: return "error_add_equal_sign_title".localized
        case .cannotConvertMathOperatorFromTag: return "error_convert_math_operator_title".localized
        }
    }
}
