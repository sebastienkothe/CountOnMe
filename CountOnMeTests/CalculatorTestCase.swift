//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 05/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.

// swiftlint:disable force_try

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    var calculatorDelegateMock: CalculatorDelegateMock!

    override func setUp() {
        calculator = Calculator()
        calculatorDelegateMock = CalculatorDelegateMock()
        calculator.delegate = calculatorDelegateMock
    }

    func testGivenExpressionsAreContainedInTheDictionary_WhenTryingToCalculateThem_ThenResultShouldBeValueOfKey() {

        // Expressions to calculate
        let expressionToCalculateWithResult = [
            "2 * 0": " = 0",
            "0 * 2": " = 0",
            "2 * -1": " = -2",
            "-2 * 0": " = 0",
            "-0 * 2": " = 0",
            "8 * -5": " = -40",
            "6 * 8 - 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 110.75",
            "6 * 8 + 3 / 1 - 8 * 9 - 5 / 4 * 5": " = -27.25",
            "6 * 8 - 3 / 1 - 8 * 9 - 5 / 4 * 5": " = -33.25",
            "6 * 8 + 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 116.75",
            "-6 * 8 - 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 14.75",
            "1 + 5 - 2 + 4 * 8": " = 36",
            "9 + 4 + 5 + 6 + 7 + 4 + 2 / 1 + 4 + 3 + 3 + 5 * 2": " = 57",
            "-9 + 4 + 5 + 6 + 7 + 4 + 2 / 1 + 4 + 3 + 3 + 5 * 2": " = 39",
            "9 + 4 - 5 + 6 + 7 + 4 - 2 / 1 + 4 - 3 + 3 + 5 * 2": " = 37",
            "-9 - 9 - 9 - 9 * 4": " = -63",
            "-1 + 2 - 1 + 4 / 2 - 3 + 6 + 5 / 2": " = 7.5",
            "-2 + 3 - 4 - 6 - 4 * 3": " = -21",
            "2 + 0": " = 2",
            "2 - 0": " = 2",
            "-6 * -2 / -2": " = -6",
            "-3 - 6 * 9 - 5 / -5 * 6 - 3 + 9": " = -45",
            "-6 + 3 + 4 / -4 + 9 + 6 - 3 * -6": " = 29"
        ]

        for (expression, result) in expressionToCalculateWithResult {
            for element in expression.elementsSplit {

                if element.isAnOperator {
                    for operatorSign in MathOperator.allCases where element == operatorSign.symbol {
                        try! calculator.addMathOperator(operatorSign)
                    }
                } else {
                    calculator.addDigit(element)
                }
            }

            try! calculator.handleTheExpressionToCalculate()
            XCTAssertEqual(calculatorDelegateMock.textToCompute, "\(expression)\(result)")
        }

    }

    func testGivenOperatorIsMinus_WhenTextToComputeIsWorthTextToComputeCase_ThenTextToComputeShouldContainMinus() {

        let textToComputeCases = ["0", "=", "ERROR", ""]

        for textToComputeCase in textToComputeCases {
            calculator.addDigit(textToComputeCase)
            try! calculator.addMathOperator(MathOperator.minus)
            XCTAssertEqual(calculatorDelegateMock.textToCompute, "-")
            calculator.cleanTextToCompute()
        }
    }

    func testTextToComputeIsWorth5Plus5Equal10_WhenTryingToAddEachOperator_ThenMethodShouldReturnAnError() {
        let mathOperators: [MathOperator] = [.plus, .multiplication, .division]

        calculator.addDigit("5")
        try! calculator.addMathOperator(mathOperators[0])
        calculator.addDigit("5")
        try! calculator.handleTheExpressionToCalculate()

        for mathOperator in mathOperators {
            XCTAssertThrowsError(try calculator.addMathOperator(mathOperator))
        }

        XCTAssertNoThrow(try calculator.addMathOperator(MathOperator.minus))
    }

    func testTextToComputeIsWorth1_WhenTryingToAddPlusOperator_ThenMethodShouldNotReturnAnError() {
        calculator.addDigit("1")

        XCTAssertNoThrow((try calculator.addMathOperator(MathOperator.plus)))
    }

    func testGivenSenderTagIsInitialized_WhenSenderTagIsAddedToTheMethod_ThenResultMustContainCorrectOperator() {

        // The MathOperator should be "+" then "-" then "*" then "/"
        for senderTag in 0...3 {
            calculator.identifyTheOperatorFromThe(senderTag) { (result) in
                XCTAssertEqual(result, MathOperator.allCases[senderTag])
            }
        }
    }

    func testGivenTextToComputeIsWorthErrorCasesKey_WhenTryingToCheckIt_ThenMethodShouldReturnAnError() {

        let errorCases: [String: CalculatorError] = [
            "1 / 0": .cannotDivideByZero, "1 + 2 = 3": .cannotAddEqualSign, "1 +": .cannotAddAMathOperator
        ]

        for (expression, errorCase) in errorCases {
            for element in expression.elementsSplit {
                if element.isAnOperator {
                    for operatorSign in MathOperator.allCases where element == operatorSign.symbol {
                        try! calculator.addMathOperator(operatorSign)
                    }
                } else {
                    calculator.addDigit(element)
                }
            }

            do {
                if errorCase != CalculatorError.cannotAddAMathOperator {
                    try calculator.handleTheExpressionToCalculate()
                } else {
                    try calculator.addMathOperator(MathOperator.multiplication)
                }
            } catch {
                XCTAssertEqual(error as? CalculatorError, errorCase)
            }
            calculator.cleanTextToCompute()
        }
    }

    // Question : how to make a useful test ?
    func testGivenCalculatorErrorContainsThreeCases_WhenTryingToAccessEachCase_ThenTitleShouldReturnTheCorrectString() {
        let calculatorErrorCases: [CalculatorError] = [
            .cannotDivideByZero, .cannotAddEqualSign, .cannotAddAMathOperator
        ]

        for calculatorErrorCase in calculatorErrorCases {
            XCTAssertEqual(calculatorErrorCase.title, calculatorErrorCase.title)
        }
    }

    func testGivenTextToComputeContainsANonConvertibleNumber_WhenTryingToConvertIt_ThenErrorMessageIsDisplayed() {

        for _ in 0...308 {
            calculator.addDigit("9")
        }
        try! calculator.addMathOperator(MathOperator.multiplication)
        calculator.addDigit("9")

        try! calculator.handleTheExpressionToCalculate()

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "ERROR")
    }

    func testGivenTextToComputeIsEmpty_WhenTryingToAddAnMinusOperatorAnd1_ThenTextToComputeShouldContainIt() {
        XCTAssertNoThrow(try! calculator.addMathOperator(MathOperator.minus))
        calculator.addDigit("1")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-1")
    }

    func testGivenTextToComputeIsReset_WhenTryingToAddAnMinusOperator_ThenTextToComputeShouldContainMinusOperator() {
        calculator.cleanTextToCompute()

        try! calculator.addMathOperator(MathOperator.minus)

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-")
    }

    func testGivenTextToComputeIsWorth1Plus0_WhenTryingToAddAZero_Then0ShouldNotBeAdded() {
        calculator.addDigit("1")
        try! calculator.addMathOperator(MathOperator.plus)
        calculator.addDigit("0")

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1 + 0")
    }

    func testGivenTextToComputeIsWorth1_WhenTryingToAddAZero_Then0ShouldBeAdded() {
        calculator.addDigit("1")

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "10")
    }

    func testGivenTextToComputeIsWorth10_WhenTryingToAddAZero_Then0ShouldBeAdded() {
        calculator.addDigit("1")
        calculator.addDigit("0")

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "100")
    }

    func testGivenTextToComputeIsWorthMinus0_WhenTryingToAddAZero_Then0ShouldNotBeAdded() {
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("0")

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-0")
    }

    func testGivenTextToComputeIsWorth1Plus0_WhenTryingToAddA1_Then1ShouldNotBeAdded() {
        calculator.addDigit("1")
        try! calculator.addMathOperator(MathOperator.plus)
        calculator.addDigit("0")

        calculator.addDigit("1")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1 + 0")
    }

    func testGivenTextToComputeIsWorth2MultipliedBy_WhenTryingToAddMinusOperator_ThenMethodShouldNotReturnAnError() {
        calculator.addDigit("2")
        try! calculator.addMathOperator(MathOperator.multiplication)

        XCTAssertNoThrow(try calculator.addMathOperator(MathOperator.minus))
    }

    func testGivenTextToComputeIsWorth8Minus_WhenTryingToAddMinusOperator_ThenMethodShouldReturnAnError() {
        calculator.addDigit("8")
        try! calculator.addMathOperator(MathOperator.minus)

        XCTAssertThrowsError(try calculator.addMathOperator(MathOperator.minus))
    }

    func testGivenTextToComputeIsWorthMinus5Minus_WhenTryingToAddPlusOperator_ThenMethodShouldReturnAnError() {
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("5")
        try! calculator.addMathOperator(MathOperator.minus)

        XCTAssertThrowsError(try calculator.addMathOperator(MathOperator.plus))
    }

    func testGivenTextToComputeIsWorthMinus6_WhenTryingToAdd0_ThenTextToComputeShouldContainIt() {
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("6")

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-60")
    }

    func testGivenTextToComputeIsWorth1Plus1_WhenTryingToCalculateThis_ThenResultShouldNotContainAComma() {
        calculator.addDigit("1")
        try! calculator.addMathOperator(MathOperator.plus)
        calculator.addDigit("1")

        try! calculator.handleTheExpressionToCalculate()

        XCTAssertNotEqual(calculatorDelegateMock.textToCompute, "1 + 1 = 2.0")
    }

    func testGivenTextToComputeIsWorth8DividedByMinus0_WhenTryingToAddAZero_Then0ShouldNotBeAdded() {
        calculator.addDigit("8")
        try! calculator.addMathOperator(MathOperator.multiplication)
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("0")

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "8 * -0")
    }

    func testGivenTextToComputeIsWorthMinus0MultipliedByMinus_WhenTryingToAddAZero_Then0ShouldBeAdded() {
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("0")
        try! calculator.addMathOperator(MathOperator.multiplication)
        try! calculator.addMathOperator(MathOperator.minus)

        calculator.addDigit("0")

        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-0 * -0")
    }
}

extension String {
    var elementsSplit: [String] {
        return self.split(separator: " ").map { "\($0)" }
    }
}
