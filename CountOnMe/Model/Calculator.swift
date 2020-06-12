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

    // MARK: - Internal methods
    func addDigit(_ digit: String) {
        if isReadyToNewCalculation { cleanTextToCompute() }
        var digitRecovered = digit

        if digitRecovered.isNull {
            if textToCompute.isEmpty { textToCompute = digitRecovered; return }
            guard let lastElement = elements.last, let firstElement = elements.first else { return }

            guard lastElement.isAnOperator || (!firstElement.isNull && !lastElement.isNull) else { return }
            if (firstElement == "-0" && !lastElement.isAnOperator) || lastElement == "-0" { return }
        } else {
            if elements.last == "0" { return }
        }

        if textToCompute == MathOperator.minus.symbol {
            digitRecovered = MathOperator.minus.symbol + digitRecovered; textToCompute = ""
        }

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
        guard let lastElement = elements.last else { return }
        if mathOperator == .minus && lastElement.isPriorityOperator { textToCompute += mathOperator.symbol; return }
        guard lastElementIsNumber && !hasAResult else { throw CalculatorError.cannotAddAMathOperator }
        textToCompute.append(" \(mathOperator.symbol) ")
    }

    func handleTheExpressionToCalculate() throws {
        guard lastElementIsNumber && hasEnoughElements && !hasAResult && !worthZero else {
            throw CalculatorError.cannotAddEqualSign }

        var operatorRecovered: String = ""
        var operationsToReduce = elements
        var remainingFromCalculation: [String] = []
        var operandRight = 0.0
        var result = 0.0

        var operandLeft = 0.0 {
            didSet {
                let optionalOperator: String? = operationsToReduce[1]
                guard let operatorFound = optionalOperator else { return }
                if operatorFound.isAnOperator { operatorRecovered = operatorFound }
            }
        }

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 || !remainingFromCalculation.isEmpty {

            if operationsToReduce.count == 1 && !remainingFromCalculation.isEmpty {
                addTheRestOfTheCalculation(&operationsToReduce, &remainingFromCalculation)
            }

            if operationsToReduce.count > 3
                && operationsToReduce[3].isPriorityOperator
                && !operationsToReduce[1].isPriorityOperator {
                handleThePriorityOperations(&operationsToReduce, &remainingFromCalculation)
            }

            convertOperandsToDouble(&operandLeft, &operandRight, operationsToReduce: operationsToReduce)
            if textToCompute == errorMessage { return }

            do {
                try performTheCalculation(operatorRecovered, operandLeft, operandRight, &result)
            } catch { throw error }

            excludeItems(&operationsToReduce, howManyItems: 3)

            operationsToReduce.insert("\(forTrailingZero(temp: result))", at: 0)
        }

        guard let resultToDisplay = operationsToReduce.first else { return }
        textToCompute += " \(equalSign) \(resultToDisplay)"
    }

    // MARK: - Private properties
    private let errorMessage = "ERROR"
    private let equalSign = "="

    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }

    private var textToCompute: String = "" {
        didSet {
            delegate?.textToComputeDidChange(textToCompute: textToCompute)
        }
    }

    private var lastElementIsNumber: Bool {
        guard let lastElement = textToCompute.last else { return false }
        return lastElement.isNumber
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

    // MARK: - Private methods
    private func performTheCalculation(
        _ operatorRecovered: String,
        _ operandLeft: Double,
        _ operandRight: Double,
        _ result: inout Double
    ) throws {
        switch operatorRecovered {
        case MathOperator.plus.symbol: result = operandLeft + operandRight
        case MathOperator.minus.symbol: result = operandLeft - operandRight
        case MathOperator.multiplication.symbol:
            if operandRight.isZero || operandLeft == -0 || operandLeft.isZero { result = 0; return }
            result = operandLeft * operandRight
        case MathOperator.division.symbol:
            guard !operandRight.isZero else { textToCompute = errorMessage ; throw CalculatorError.cannotDivideByZero }
            result = operandLeft / operandRight
        default: return }
    }

    private func convertOperandsToDouble(
        _ operandLeft: inout Double,
        _ operandRight: inout Double,
        operationsToReduce: [String]
    ) {
        guard
            let operandLeftConverted = Double(operationsToReduce[0]),
            let operandRightConverted = Double(operationsToReduce[2])
            else { cleanTextToCompute(); textToCompute = errorMessage ; return }

        operandLeft = operandLeftConverted
        operandRight = operandRightConverted
    }

    private func handleTheNearestPriorityCalculation(
        _ remainingFromCalculation: inout [String],
        _ operationsToReduce: inout [String],
        operatorIsNegative: Bool) {

        let operatorRequired = operatorIsNegative ? MathOperator.minus.symbol : MathOperator.plus.symbol
        remainingFromCalculation.append(operatorRequired)

        if operatorIsNegative { operationsToReduce[0].removeFirst() }

        remainingFromCalculation.append(operationsToReduce[0])
        operationsToReduce.removeFirst()
        operationsToReduce[0] += operationsToReduce[1]
        operationsToReduce.remove(at: 1)
    }

    private func addTheRestOfTheCalculation(
        _ operationsToReduce: inout [String],
        _ remainingFromCalculation: inout [String]) {
        operationsToReduce += remainingFromCalculation
        remainingFromCalculation = []
    }

    private func handleThePriorityOperations(
        _ operationsToReduce: inout [String],
        _ remainingFromCalculation: inout [String]) {
        let numberIsNegative = operationsToReduce[0] == MathOperator.minus.symbol
        handleTheNearestPriorityCalculation(
            &remainingFromCalculation,
            &operationsToReduce,
            operatorIsNegative: numberIsNegative)
    }

    private func excludeItems(_ operationsToReduce: inout [String], howManyItems: Int) {
        operationsToReduce = Array(operationsToReduce.dropFirst(howManyItems))
    }

    private func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
}

extension String {

    var isPriorityOperator: Bool {
        self == MathOperator.multiplication.symbol || self == MathOperator.division.symbol
    }

    var isAnOperator: Bool {
        for operatorSign in MathOperator.allCases
            where self == operatorSign.symbol.trimmingCharacters(in: .whitespaces) {
            return true
        }
        return false
    }

    var isNull: Bool {
        self == "0"
    }
}
