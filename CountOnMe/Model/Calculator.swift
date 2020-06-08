//
//  Calculator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length

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
    
    private var lastElementIsNumber: Bool {
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
        var digitRecovered = digit
        if textToCompute.trimmingCharacters(in: .whitespaces) == "-" { digitRecovered = "-" + digitRecovered; textToCompute.removeAll()}
        if worthZero || hasAResult || hasAErrorMessage { resetOperation() }
        textToCompute.append(digitRecovered)
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
        if (textToCompute == "" || textToCompute == "0" || textToCompute.contains("=") || textToCompute.contains("ERROR")) && mathOperator == .minus { textToCompute.removeAll(); textToCompute.append(mathOperator.symbol); return }
        guard lastElementIsNumber && !hasAResult && !worthZero else { throw CalculatorError.cannotAddAMathOperator }
        textToCompute.append(mathOperator.symbol)
    }
    
    private func addTheRestOfTheCalculation(_ operationsToReduce: inout [String], _ remainingFromCalculation: inout [String]) {
        operationsToReduce.append(contentsOf: remainingFromCalculation)
        remainingFromCalculation.removeAll()
    }
    
    private func handleThePriorityOperations(_ operationsToReduce: inout [String], _ remainingFromCalculation: inout [String]) {
        let numberIsNegative = operationsToReduce[0].isNegativeNumber
        handleTheNearestPriorityCalculation(&remainingFromCalculation, &operationsToReduce, operatorIsNegative: numberIsNegative)
    }
    
    func handleTheExpressionToCalculate() throws {
        guard lastElementIsNumber && hasEnoughElements && !hasAResult && !worthZero else {
            throw CalculatorError.cannotAddEqualSign }
        
        var operationsToReduce = elements; var remainingFromCalculation: [String] = []; var operandLeft = 0.0; var operandRight = 0.0; var result: Double = 0.0
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 || !remainingFromCalculation.isEmpty {
            
            if operationsToReduce.count == 1 && !remainingFromCalculation.isEmpty {
                addTheRestOfTheCalculation(&operationsToReduce, &remainingFromCalculation)
            }
            
            var operatorRecovered = operationsToReduce[1]
            
            if operationsToReduce.count > 3 && operationsToReduce[3].isPriorityOperator {
                handleThePriorityOperations(&operationsToReduce, &remainingFromCalculation)
            }
            
            operatorRecovered = operationsToReduce[1]
            
            convertOperandsToDouble(&operandLeft, &operandRight, operationsToReduce: operationsToReduce)
            
            if textToCompute == errorMessage { return }
            
            do {
                try performTheCalculation(operatorRecovered: operatorRecovered, operandLeft: operandLeft, operandRight: operandRight, &result)
            }
            catch { throw error }
            
            excludeItems(&operationsToReduce, howManyItems: 3)
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textToCompute.append(" = \(operationsToReduce[0])")
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

    private func convertOperandsToDouble(_ operandLeft: inout Double, _ operandRight: inout Double, operationsToReduce: [String]) {
        guard let operandLeftConverted = Double(operationsToReduce[0]), let operandRightConverted = Double(operationsToReduce[2]) else { textToCompute.removeAll(); textToCompute = errorMessage ; return }
        
        operandLeft = operandLeftConverted
        operandRight = operandRightConverted
    }
    
    private func handleTheNearestPriorityCalculation(_ remainingFromCalculation: inout [String], _ operationsToReduce: inout [String], operatorIsNegative: Bool) {
        let operatorRequired = operatorIsNegative ? "-" : "+"
        remainingFromCalculation.append(operatorRequired)
        if operatorIsNegative { operationsToReduce[0].removeFirst() }
        remainingFromCalculation.append(operationsToReduce[0])
        operationsToReduce.removeFirst()
        operationsToReduce[0] += operationsToReduce[1]
        operationsToReduce.remove(at: 1)
    }
    
    private func excludeItems(_ operationsToReduce: inout [String], howManyItems: Int) {
        operationsToReduce = Array(operationsToReduce.dropFirst(howManyItems))
    }
}

extension String {
    var isPriorityOperator: Bool {
        self == "*" || self == "/"
    }
    
    var isNegativeNumber: Bool {
        self.contains("-")
    }
}
