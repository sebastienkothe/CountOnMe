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
    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }
    
    var textToCompute: String = "" {
        didSet {
            delegate?.textToComputeDidChange(textToCompute: textToCompute)
        }
    }
    
    var canAddMathOperator: Bool  {
        guard let lastElementFromTextToCompute = textToCompute.last else { return false }
        return lastElementFromTextToCompute.isNumber
    }
    
    var expressionContainsEnoughElements: Bool {
        return textToCompute.count > 2
    }
    
    var canAddEqualOperator: Bool {
        guard let lastElementFromTextToCompute = textToCompute.trimmingCharacters(in: .whitespaces).last else { return false }
        return lastElementFromTextToCompute.isNumber
    }
    
    var expressionContainsAResult: Bool {
        return textToCompute.contains("=")
    }
    
    func addDigit(_ digit: String) {
        if expressionContainsAResult { textToCompute = "" }
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
        guard !expressionContainsAResult else { textToCompute = "" ; throw CalculatorError.cannotModifyAnExpressionContainingAResult }
        textToCompute.append(mathOperator.symbol)
    }
    
    func resolveOperation() throws {
        // Create local copy of operations
        var operationsToReduce = elements
        
        guard canAddEqualOperator else {
            throw CalculatorError.cannotCalculateAnExpressionEndingWithMathOperator
        }
        
        guard textToCompute.count != 1 else {
            throw CalculatorError.CannotComputeAnExpressionWithoutMathOperator
        }
        
        //        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            guard let operandLeft = Double(operationsToReduce[0]), let operandRight = Double(operationsToReduce[2]) else { textToCompute = "ERROR" ; return }
            let operatorRecovered = operationsToReduce[1]
            var result = 0.0
            
            switch operatorRecovered {
            case "+": result = operandLeft + operandRight
            case "-": result = operandLeft - operandRight
            case "*": result = operandLeft * operandRight
            case "/": result = operandLeft / operandRight
                
            default:
                return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        textToCompute.append(" = \(operationsToReduce.first!)")
    }
    
    // MARK: - Internal methods
}
