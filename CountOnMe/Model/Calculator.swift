//
//  Calculator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Internal properties
    var delegate: CalculatorDelegate?
    
    // MARK: - Private properties
    private let errorMessage = "ERROR"
    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }
    
    private var textToCompute: String = "0" {
        didSet {
            delegate?.textToComputeDidChange(textToCompute: textToCompute)
        }
    }
    
    private var lastElementIsNumber: Bool  {
        guard let lastElementFromTextToCompute = textToCompute.last else { return false }
        return lastElementFromTextToCompute.isNumber
    }
    
    private var hasEnoughElements: Bool {
        elements.count >= 3
    }
    
    private var hasAResult: Bool {
        textToCompute.contains("=")
    }
    
    private var worthZero: Bool {
        textToCompute == "0"
    }
    
    private var hasAErrorMessage: Bool {
        return textToCompute == errorMessage
    }
    
    // MARK: - Internal methods
    func addDigit(_ digit: String) {
        if worthZero || hasAResult || hasAErrorMessage { resetOperation() }
        textToCompute.append(digit)
    }
    
    func identifyTheOperatorFromThe(_ senderTag: Int, completionHandler: (MathOperator?) -> Void) {
        for (index, operatorName) in MathOperator.allCases.enumerated() where index == senderTag {
            completionHandler(operatorName)
        }
    }
    
    func resetOperation() {
        textToCompute = ""
    }
    
    
    func addMathOperator(_ mathOperator: MathOperator) throws {
        guard lastElementIsNumber && !hasAResult && !worthZero else { throw CalculatorError.cannotAddAMathOperator }
        textToCompute.append(mathOperator.symbol)
    }
    
    fileprivate func isolateNonPriorityOperations(_ remainingFromCalculation: inout [String], _ operationsToReduce: inout [String], operatorIndex: Int, numberIndex: Int) {
        remainingFromCalculation.append(contentsOf: [operationsToReduce[operatorIndex], operationsToReduce[numberIndex]])
    }
    
    func resolveOperation() throws {
        guard lastElementIsNumber && hasEnoughElements && !hasAResult && !worthZero else {
            throw CalculatorError.cannotAddEqualSign }
        
        // Create local copy of operations
        var operationsToReduce = elements
        var remainingFromCalculation: [String] = []
        var result = 0.0
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            var operatorRecovered = operationsToReduce[1]
            
            while (operatorRecovered == "+" || operatorRecovered == "-") && (operationsToReduce.contains("*") || operationsToReduce.contains("/")) {
                
                if result > 0 {
                    isolateNonPriorityOperations(&remainingFromCalculation, &operationsToReduce, operatorIndex: 1, numberIndex: 2)
                    guard let resultToSave = operationsToReduce.first else { return }
                    operationsToReduce = Array(operationsToReduce.dropFirst(3))
                    operationsToReduce.insert(resultToSave, at: 0)
                } else {
                    isolateNonPriorityOperations(&remainingFromCalculation, &operationsToReduce, operatorIndex: 1, numberIndex: 0)
                    operationsToReduce = Array(operationsToReduce.dropFirst(2))
                }
                operatorRecovered = operationsToReduce[1]
                result = 0.0
            }
            
            guard let operandLeft = Double(operationsToReduce[0]), let operandRight = Double(operationsToReduce[2]) else { textToCompute = errorMessage ; return }
            
            switch operatorRecovered {
            case "+": result = operandLeft + operandRight
            case "-": result = operandLeft - operandRight
            case "*": result = operandLeft * operandRight
            case "/":
                guard operandRight != 0 else { textToCompute = errorMessage ; throw CalculatorError.cannotDivideByZero }
                result = operandLeft / operandRight
            default: return }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textToCompute.append(" = \(operationsToReduce.first!)")
    }
}
