//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 05/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
// swiftlint:disable trailing_whitespace
// swiftlint:disable force_try


//    func generateRandomOperator() -> MathOperator {
//        let randomNumber = Int.random(in: 0...3)
//        let randomOperatorGenerated = MathOperator.allCases[randomNumber]
//        return randomOperatorGenerated
//    }
//
//    func generateRandomNumbersAsString() -> String {
//        //       let randomNumber = Int.random(in: 0...3)
//        //        return randomNumber
//        return ""
//    }


import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    var calculatorDelegateMock: CalculatorDelegateMock!
    var textToComputeCases: [String]!
    var operatorSign: MathOperator!
    var cannotDivideByZeroCase: CalculatorError!
    var cannotAddEqualSignCase : CalculatorError!
    var cannotAddAMathOperatorCase : CalculatorError!
    
    override func setUp() {
        calculator = Calculator()
        calculatorDelegateMock = CalculatorDelegateMock()
        calculator.delegate = calculatorDelegateMock
        textToComputeCases = ["0", "=", "ERROR", ""]
        cannotDivideByZeroCase = .cannotDivideByZero
        cannotAddEqualSignCase = .cannotAddEqualSign
        cannotAddAMathOperatorCase = .cannotAddAMathOperator
    }
    
    func testGivenExpressionsAreContainedInTheDictionary_WhenTryingToCalculateThem_ThenResultShouldBeValueOfKey() {
        
        // Expressions to calculate
        let expressionToCalculateWithResult = [
            "666 * 888 - 333 / 1 + 8 * 999 - 5 / 4 * 555": " = 598373.25",
            "666 * 888 + 333 / 1 - 8 * 999 - 5 / 4 * 555": " = 583055.25",
            "666 * 888 - 333 / 1 - 8 * 999 - 5 / 4 * 555": " = 582389.25",
            "666 * 888 + 333 / 1 + 8 * 999 - 5 / 4 * 555": " = 599039.25",

            "-666 * 888 - 333 / 1 + 8 * 999 - 5 / 4 * 555": " = -584442.75",
            "1 + 5 - 2 + 4 * 8": " = 36.0",
            "9 + 4 + 5 + 6 + 7 + 4 + 2 / 1 + 4 + 3 + 3 + 5 * 2": " = 57.0",
            "-9 + 4 + 5 + 6 + 7 + 4 + 2 / 1 + 4 + 3 + 3 + 5 * 2": " = 39.0",
            "9 + 4 - 5 + 6 + 7 + 4 - 2 / 1 + 4 - 3 + 3 + 5 * 2": " = 37.0",
            "6 * 8 - 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 110.75",
            "-9 - 9 - 9 - 9 * 4": " = -63.0",
            "-1 + 2 - 1 + 4 / 2 - 3 + 6 + 5 / 2": " = 7.5",
            "-2 + 3 - 4 - 6 - 4 * 3": " = -21.0",
            "222 + 0": " = 222.0",
            "222 - 0": " = 222.0",
            "222 * 0": " = 0.0"
        ]
        
        for expression in expressionToCalculateWithResult {
            calculator.addDigit(expression.key)
            
            try! calculator.handleTheExpressionToCalculate()
            
            XCTAssertEqual(calculatorDelegateMock.textToCompute, "\(expression.key)\(expression.value)")
        }
    }
    
    func testGivenOperatorIsMinus_WhenTextToComputeIsWorthTextToComputeCase_ThenTextToComputeShouldContainMinus() {
        operatorSign = .minus
        
        for textToComputeCase in textToComputeCases {
            calculator.addDigit(textToComputeCase)
            try! calculator.addMathOperator(operatorSign)
            XCTAssertEqual(calculatorDelegateMock.textToCompute, "-")
            calculator.cleanTextToCompute()
        }
    }
    
    func testTextToComputeIsWorthTextToComputeCase_WhenTextToComputeIsWorthTextToComputeCase_ThenMethodShouldReturnAnError() {
        operatorSign = .plus
        textToComputeCases = ["*", "0", "="]
        
        for textToComputeCase in textToComputeCases {
            calculator.addDigit(textToComputeCase)
            XCTAssertThrowsError(try calculator.addMathOperator(operatorSign))
            calculator.cleanTextToCompute()
        }
    }
    
    func testTextToComputeIsWorth1_WhenTryingToAddPlusOperator_ThenMethodShouldNotReturnAnError() {
        operatorSign = .plus
        calculator.addDigit("1")
        
        XCTAssertNoThrow((try calculator.addMathOperator(operatorSign)))
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
        
        let errorCases = ["1 / 0": cannotDivideByZeroCase, "1 + 2 = 3": cannotAddEqualSignCase, "1 +": cannotAddAMathOperatorCase]
        
        for (expression, errorCase) in errorCases {
            calculator.addDigit(expression)
            
            do {
                if errorCase != cannotAddAMathOperatorCase { try calculator.handleTheExpressionToCalculate() } else {
                    try calculator.addMathOperator(MathOperator.multiplication)
                }
            } catch {
                XCTAssertEqual(error as? CalculatorError, errorCase)
            }
            calculator.cleanTextToCompute()
        }
    }
    
    func testGivenCalculatorErrorContainsThreeCases_WhenTryingToAccessEachCase_ThenTitleShouldReturnTHeCorrectString() {
        let calculatorErrorCases = [cannotDivideByZeroCase, cannotAddEqualSignCase, cannotAddAMathOperatorCase]
        
        for calculatorErrorCase in calculatorErrorCases {
            XCTAssertEqual(calculatorErrorCase?.title, calculatorErrorCase?.title)
        }
    }
    
    func testGivenTextToComputeContainsNumberImpossibleToConvertToDouble_WhenTryingToConvertIt_ThenTextToComputeShouldContainErrorMesssage() {
        
        calculator.addDigit("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 * 9")
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "ERROR")
        calculator.addDigit("1")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1")
    }
    
    func testGivenTextToComputeIsEmpty_WhenTryingToAddAnMinusOperator_ThenTextToComputeShouldContainMinusOperator() {
        XCTAssertNoThrow(try! calculator.addMathOperator(MathOperator.minus))
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-")
    }
    
    func testGivenTextToComputeIsReset_WhenTryingToAddAnMinusOperator_ThenTextToComputeShouldContainMinusOperator() {
        calculator.addDigit("1 + 1")
        try! calculator.handleTheExpressionToCalculate()
        calculator.cleanTextToCompute()
        
        XCTAssertNoThrow(try! calculator.addMathOperator(MathOperator.minus))
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-")
    }
    
    func testGivenTextToComputeIsWorth1AndPlus0_WhenTryingToAddAZero_Then0ShouldNotBeAdded() {
        calculator.addDigit("1 + 0")
        calculator.addDigit("0")
        XCTAssertNotEqual(calculatorDelegateMock.textToCompute, "1 + 00")
    }
    
    func testGivenTextToComputeIsWorth1_WhenTryingToAddAZero_Then0ShouldBeAdded() {
        calculator.addDigit("1")
        calculator.addDigit("0")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "10")
    }
}

