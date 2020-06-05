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
    
    func handleTheExpressionToCalculate() throws {
        guard lastElementIsNumber && hasEnoughElements && !hasAResult && !worthZero else {
            throw CalculatorError.cannotAddEqualSign }
        
        // Create local copy of operations
        var operationsToReduce = elements
        var remainingFromCalculation: [String] = []
        var result: Double = 0.0 {
            didSet {
                hasResult = true
            }
        }
        
        var operandLeft = 0.0
        var operandRight = 0.0
        var hasResult = false
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 || !remainingFromCalculation.isEmpty {
            
            if operationsToReduce.count == 1 && !remainingFromCalculation.isEmpty {
                operationsToReduce.append(contentsOf: remainingFromCalculation)
                remainingFromCalculation.removeAll()
            }
            
            var operatorRecovered = operationsToReduce[1]
            
            while (operatorRecovered == "+" || operatorRecovered == "-") && (operationsToReduce.contains("*") || operationsToReduce.contains("/")) {
                
                if operatorRecovered == "-" && (operationsToReduce[3] == "*" || operationsToReduce[3] == "/") {
                    if operationsToReduce[0].contains("-") {
                        remainingFromCalculation.append("-"); operationsToReduce[0].removeFirst(); remainingFromCalculation.append(operationsToReduce[0]); operationsToReduce.removeFirst()
                        operationsToReduce[0] += operationsToReduce[1]
                        operationsToReduce.remove(at: 1)
                        break
                    } else {
                        remainingFromCalculation.append("+")
                        remainingFromCalculation.append(operationsToReduce[0]); operationsToReduce.removeFirst()
                        operationsToReduce[0] += operationsToReduce[1]
                        operationsToReduce.remove(at: 1)
                        break
                    }
                }
                
                if hasResult {
                    isolateNonPriorityOperations(&remainingFromCalculation, &operationsToReduce, operatorIndex: 1, numberIndex: 2)
                    guard let resultToSave = operationsToReduce.first else { return }
                    operationsToReduce = Array(operationsToReduce.dropFirst(3))
                    operationsToReduce.insert(resultToSave, at: 0)
                } else {
                    isolateNonPriorityOperations(&remainingFromCalculation, &operationsToReduce, operatorIndex: 1, numberIndex: 0)
                    operationsToReduce = Array(operationsToReduce.dropFirst(2))
                }
                operatorRecovered = operationsToReduce[1]
                hasResult = false
            }
            
            operatorRecovered = operationsToReduce[1]
            
            
            convertOperandsToDouble(&operandLeft, &operandRight, operationsToReduce: operationsToReduce)
            
            do { try performTheCalculation(operatorRecovered: operatorRecovered, operandLeft: operandLeft, operandRight: operandRight, &result) }
            catch { throw error }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textToCompute.append(" = \(operationsToReduce.first!)")
    }
    
    // MARK: - Private methods
    private func performTheCalculation(operatorRecovered: String, operandLeft: Double, operandRight: Double, _ result: inout Double) throws {
        switch operatorRecovered {
        case "+": result = operandLeft + operandRight
        case "-": result = operandLeft - operandRight
        case "*": result = operandLeft * operandRight
        case "/":
            guard operandRight != 0 else { textToCompute = errorMessage ; throw CalculatorError.cannotDivideByZero }
            result = operandLeft / operandRight
        default: return }
        
    }
    
    private func isolateNonPriorityOperations(_ remainingFromCalculation: inout [String], _ operationsToReduce: inout [String], operatorIndex: Int, numberIndex: Int) {
        remainingFromCalculation.append(contentsOf: [operationsToReduce[operatorIndex], operationsToReduce[numberIndex]])
    }
    
    private func convertOperandsToDouble(_ operandLeft: inout Double, _ operandRight: inout Double, operationsToReduce: [String]) {
        guard let operandLeftConverted = Double(operationsToReduce[0]), let operandRightConverted = Double(operationsToReduce[2]) else { textToCompute = errorMessage ; return }
        operandLeft = operandLeftConverted
        operandRight = operandRightConverted
    }
}
