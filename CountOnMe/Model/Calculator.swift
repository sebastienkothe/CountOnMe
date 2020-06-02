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
    
    var textToCompute: String = "" {
        didSet {
            delegate?.textToComputeDidChange(textToCompute: textToCompute)
        }
    }
    
    var canAddMathOperator: Bool  {
        guard let lastElementFromTextToCompute = textToCompute.last else { return false }
        return lastElementFromTextToCompute.isNumber
    }
    
    func addDigit(_ digit: String) {
        textToCompute.append(digit)
    }
    
    func resetOperation() {
        textToCompute.removeAll()
    }
    
    func identifyTheOperatorFromThe(_ senderTag: Int, completionHandler: @escaping (Result<MathOperator, CalculatorError>) -> Void) {
        for (index, operatorName) in MathOperator.allCases.enumerated() where index == senderTag {
            completionHandler(.success(operatorName))
            return
        }
        completionHandler(.failure(.cannotIdentifyOperator))
    }
    
    func addMathOperator(_ mathOperator: MathOperator) throws {
        guard canAddMathOperator else { throw CalculatorError.cannotAddAMathOperator }
        textToCompute.append(mathOperator.symbol)
    }
    
    // MARK: - Internal methods
//    internal func performTheOperation(_ operatorRecovered: String, _ operandLeft: Int, _ operandRight: Int) -> Int? {
//        let result: Int?
//
//        switch operatorRecovered {
//        case "+": result = operandLeft + operandRight
//        case "-": result = operandLeft - operandRight
//        case "*": result = operandLeft * operandRight
//        case "/": result = operandLeft / operandRight
//
//        default:
//            return nil
//        }
//
//        return result
//    }
    

}
