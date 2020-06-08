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
    
    override func setUp() {
        calculator = Calculator()
        calculatorDelegateMock = CalculatorDelegateMock()
        calculator.delegate = calculatorDelegateMock
        textToComputeCases = ["", "0", "=", "ERROR"]
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
            "-9 - 9 - 9 - 9 * 4": " = -63.0"
            
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
            XCTAssertEqual(calculatorDelegateMock.textToCompute, " - ")
            calculator.resetOperation()
        }
    }
    
    func testTextToComputeIsWorthTextToComputeCase_WhenTextToComputeIsWorthTextToComputeCase_ThenMethodShouldReturnAnError() {
        operatorSign = .plus
        textToComputeCases = ["*", "0", "="]
        
        for textToComputeCase in textToComputeCases {
            calculator.addDigit(textToComputeCase)
            XCTAssertThrowsError(try calculator.addMathOperator(operatorSign))
            calculator.resetOperation()
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
        
        let cannotDivideByZeroCase = CalculatorError.cannotDivideByZero
        let cannotAddEqualSignCase = CalculatorError.cannotAddEqualSign
        let cannotAddAMathOperatorCase = CalculatorError.cannotAddAMathOperator
        
        let errorCases = ["1 / 0": cannotDivideByZeroCase, "1 + 2 = 3": cannotAddEqualSignCase, "1 +": cannotAddAMathOperatorCase]
        
        for (expression, errorCase) in errorCases {
            calculator.addDigit(expression)
            
            do {
                if errorCase != cannotAddAMathOperatorCase { try calculator.handleTheExpressionToCalculate() } else {
                    try calculator.addMathOperator(MathOperator.multiplication)
                }
            } catch {
                XCTAssertEqual(error as! CalculatorError, errorCase)
            }
            calculator.resetOperation()
        }
    }
}

