//
//  Calculator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

class Calculator {

    var delegate: CalculatorDelegate?
    
    // MARK: - Internal methods
    internal func performTheOperation(_ operatorRecovered: String, _ operandLeft: Int, _ operandRight: Int) -> Int? {
        let result: Int?

        switch operatorRecovered {
        case "+": result = operandLeft + operandRight
        case "-": result = operandLeft - operandRight
        case "*": result = operandLeft * operandRight
        case "/": result = operandLeft / operandRight

        default:
            return nil
        }

        return result
    }
    
    var textToCompute: String = "" {
        didSet {
            delegate?.textToComputeDidChange(textToCompute: textToCompute)
        }
    }
    
    private func addDigit(_ digit: Int) {
    }

}
