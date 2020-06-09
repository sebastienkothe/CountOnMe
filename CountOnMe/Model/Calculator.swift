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
    private let equalSign = "="
    
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
        textToCompute.contains(equalSign)
    }
    
    private var worthZero: Bool {
        textToCompute.isNull
    }
    
    private var hasAErrorMessage: Bool {
        return textToCompute == errorMessage
    }
    
    private var isReadyToNewCalculation: Bool {
        worthZero || hasAResult || hasAErrorMessage || textToCompute.isEmpty
    }
    
    // MARK: - Internal methods
    func addDigit(_ digit: String) {
        var digitRecovered = digit
        
        if digitRecovered.isNull {
            guard let lastElement = elements.last, let firstElement = elements.first else { return }
            guard lastElement.isAnOperator || (!firstElement.isNull && !lastElement.isNull) else { return }
        }
        
        if textToCompute == MathOperator.minus.symbol { digitRecovered = MathOperator.minus.symbol + digitRecovered; textToCompute.removeAll()}
        if isReadyToNewCalculation { cleanTextToCompute() }
        textToCompute.append(digitRecovered)
    }
    
    func identifyTheOperatorFromThe(_ senderTag: Int, completionHandler: (MathOperator?) -> Void) {
        for (index, operatorName) in MathOperator.allCases.enumerated() where index == senderTag {
            completionHandler(operatorName)
        }
    }
    
    func cleanTextToCompute() {
        textToCompute = ""
    }
    
    func addMathOperator(_ mathOperator: MathOperator) throws {
        if isReadyToNewCalculation && mathOperator == .minus { textToCompute = mathOperator.symbol; return }
        guard lastElementIsNumber && !hasAResult && !worthZero else { throw CalculatorError.cannotAddAMathOperator }
        textToCompute.append(" \(mathOperator.symbol) ")
    }
    
    private func addTheRestOfTheCalculation(_ operationsToReduce: inout [String], _ remainingFromCalculation: inout [String]) {
        operationsToReduce += remainingFromCalculation
        remainingFromCalculation = []
    }
    
    private func handleThePriorityOperations(_ operationsToReduce: inout [String], _ remainingFromCalculation: inout [String]) {
        let numberIsNegative = operationsToReduce[0] == MathOperator.minus.symbol
        handleTheNearestPriorityCalculation(&remainingFromCalculation, &operationsToReduce, operatorIsNegative: numberIsNegative)
    }
    
    func handleTheExpressionToCalculate() throws {
        guard lastElementIsNumber && hasEnoughElements && !hasAResult && !worthZero else {
            throw CalculatorError.cannotAddEqualSign }
        
        var operatorRecovered: String?; var operationsToReduce = elements; var remainingFromCalculation = [String](); var operandLeft = 0.0 { didSet { if operationsToReduce[1].isAnOperator { operatorRecovered = operationsToReduce[1] }}}; var operandRight = 0.0; var result: Double = 0.0;
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 || !remainingFromCalculation.isEmpty {
            
            if operationsToReduce.count == 1 && !remainingFromCalculation.isEmpty {
                addTheRestOfTheCalculation(&operationsToReduce, &remainingFromCalculation)
            }
            
            if operationsToReduce.count > 3 && operationsToReduce[3].isPriorityOperator {
                handleThePriorityOperations(&operationsToReduce, &remainingFromCalculation)
            }
            
            convertOperandsToDouble(&operandLeft, &operandRight, operationsToReduce: operationsToReduce)
            
            if textToCompute == errorMessage { return }
            
            do {
                guard let operatorRecovered = operatorRecovered else { return }
                try performTheCalculation(operatorRecovered: operatorRecovered, operandLeft: operandLeft, operandRight: operandRight, &result)
            }
            catch { throw error }
            
            excludeItems(&operationsToReduce, howManyItems: 3)
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        if !operationsToReduce[0].isEmpty { textToCompute += " \(equalSign) \(operationsToReduce[0])" }
    }
    
    // MARK: - Private methods
    private func performTheCalculation(operatorRecovered: String, operandLeft: Double, operandRight: Double, _ result: inout Double) throws {
        switch operatorRecovered {
        case MathOperator.plus.symbol: result = operandLeft + operandRight
        case MathOperator.minus.symbol: result = operandLeft - operandRight
        case MathOperator.multiplication.symbol: result = operandLeft * operandRight
        case MathOperator.division.symbol:
            guard !operandRight.isZero else { textToCompute = errorMessage ; throw CalculatorError.cannotDivideByZero }
            result = operandLeft / operandRight
        default: return }
    }
    
    private func convertOperandsToDouble(_ operandLeft: inout Double, _ operandRight: inout Double, operationsToReduce: [String]) {
        guard let operandLeftConverted = Double(operationsToReduce[0]), let operandRightConverted = Double(operationsToReduce[2]) else { cleanTextToCompute(); textToCompute = errorMessage ; return }
        
        operandLeft = operandLeftConverted
        operandRight = operandRightConverted
    }
    
    private func handleTheNearestPriorityCalculation(_ remainingFromCalculation: inout [String], _ operationsToReduce: inout [String], operatorIsNegative: Bool) {
        
        let operatorRequired = operatorIsNegative ? MathOperator.minus.symbol : MathOperator.plus.symbol
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
        
    var isAnOperator: Bool {
        for operatorSign in MathOperator.allCases where self == operatorSign.symbol.trimmingCharacters(in: .whitespaces) {
            return true
        }
        return false
    }
    
    var isNull: Bool {
        self == "0"
    }
}
