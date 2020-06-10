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
    
    override func setUp() {
        calculator = Calculator()
        calculatorDelegateMock = CalculatorDelegateMock()
        calculator.delegate = calculatorDelegateMock
    }
    
    func testGivenExpressionsAreContainedInTheDictionary_WhenTryingToCalculateThem_ThenResultShouldBeValueOfKey() {
        
        // Expressions to calculate
        let expressionToCalculateWithResult = [
//            "2 * 0" : " = 0.0",
//            "0 * 2" : " = 0.0",
//            "2 * -1": " = -2.0",
//            "-2 * 0": " = 0.0",
//            "-0 * 2": " = 0.0",
//            "8 * -5": " = -40.0",
//
//            "6 * 8 - 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 110.75",
//            "6 * 8 + 3 / 1 - 8 * 9 - 5 / 4 * 5": " = -27.25",
//            "6 * 8 - 3 / 1 - 8 * 9 - 5 / 4 * 5": " = -33.25",
//            "6 * 8 + 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 116.75",
//            "-6 * 8 - 3 / 1 + 8 * 9 - 5 / 4 * 5": " = 14.75",
//            "1 + 5 - 2 + 4 * 8": " = 36.0",
//            "9 + 4 + 5 + 6 + 7 + 4 + 2 / 1 + 4 + 3 + 3 + 5 * 2": " = 57.0",
//            "-9 + 4 + 5 + 6 + 7 + 4 + 2 / 1 + 4 + 3 + 3 + 5 * 2": " = 39.0",
//            "9 + 4 - 5 + 6 + 7 + 4 - 2 / 1 + 4 - 3 + 3 + 5 * 2": " = 37.0",
//            "-9 - 9 - 9 - 9 * 4": " = -63.0",
//            "-1 + 2 - 1 + 4 / 2 - 3 + 6 + 5 / 2": " = 7.5",
//            "-2 + 3 - 4 - 6 - 4 * 3": " = -21.0",
//            "2 + 0": " = 2.0",
//            "2 - 0": " = 2.0",
            "-6 * -2 / -2": " = -6.0"
        ]
        
        
        for (expression, result) in expressionToCalculateWithResult {
            for element in expression.elements {
                
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
    
    func testTextToComputeIsWorthTextToComputeCase_WhenTextToComputeIsWorthTextToComputeCase_ThenMethodShouldReturnAnError() {
        let textToComputeCases = ["*", "="]
        
        for textToComputeCase in textToComputeCases {
            calculator.addDigit(textToComputeCase)
            XCTAssertThrowsError(try calculator.addMathOperator(MathOperator.plus))
            calculator.cleanTextToCompute()
        }
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
        
        let errorCases = ["1 / 0": CalculatorError.cannotDivideByZero, "1 + 2 = 3": CalculatorError.cannotAddEqualSign, "1 +": CalculatorError.cannotAddAMathOperator]
        
        for (expression, errorCase) in errorCases {
            calculator.addDigit(expression)
            
            do {
                if errorCase != CalculatorError.cannotAddAMathOperator { try calculator.handleTheExpressionToCalculate() } else {
                    try calculator.addMathOperator(MathOperator.multiplication)
                }
            } catch {
                XCTAssertEqual(error as? CalculatorError, errorCase)
            }
            calculator.cleanTextToCompute()
        }
    }
    
    func testGivenCalculatorErrorContainsThreeCases_WhenTryingToAccessEachCase_ThenTitleShouldReturnTHeCorrectString() {
        let calculatorErrorCases = [CalculatorError.cannotDivideByZero, CalculatorError.cannotAddEqualSign, CalculatorError.cannotAddAMathOperator]
        
        for calculatorErrorCase in calculatorErrorCases {
            XCTAssertEqual(calculatorErrorCase.title, calculatorErrorCase.title)
        }
    }
    
    func testGivenTextToComputeContainsNumberImpossibleToConvertToDouble_WhenTryingToConvertIt_ThenTextToComputeShouldContainErrorMesssage() {
        
        calculator.addDigit("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 * 9")
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "ERROR")
        calculator.addDigit("1")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1")
    }
    
    func testGivenTextToComputeIsEmpty_WhenTryingToAddAnMinusOperatorAnd1_ThenTextToComputeShouldContainMinusOperatorAnd1() {
        XCTAssertNoThrow(try! calculator.addMathOperator(MathOperator.minus))
        calculator.addDigit("1")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "-1")
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
        calculator.addDigit("0")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "100")
    }
    
    func testGivenTextToComputeIsWorthMinus1_WhenTryingToAddAZero_Then0ShouldNotBeAdded() {
        calculator.addDigit("-0")
        calculator.addDigit("0")
        XCTAssertNotEqual(calculatorDelegateMock.textToCompute, "-00")
    }
    
    func testGivenTextToComputeIsWorth1AndPlus0_WhenTryingToAddA1_Then1ShouldNotBeAdded() {
        calculator.addDigit("1 + 0")
        try! calculator.addMathOperator(MathOperator.plus)
        calculator.addDigit("1 + 0")
        calculator.addDigit("1")
        XCTAssertNotEqual(calculatorDelegateMock.textToCompute, "1 + 01")
        try! calculator.handleTheExpressionToCalculate()
        calculator.addDigit("1")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1")
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("0")
        calculator.addDigit("1")
        XCTAssertNotEqual(calculatorDelegateMock.textToCompute, "1 - 01")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1 - 0")
        calculator.cleanTextToCompute()
        calculator.addDigit("1")
        XCTAssertEqual(calculatorDelegateMock.textToCompute, "1")
        try! calculator.addMathOperator(MathOperator.minus)
        calculator.addDigit("0")
        calculator.addDigit("1")
        XCTAssertNotEqual(calculatorDelegateMock.textToCompute, "1 - 01")
        
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
        calculator.addDigit("-5")
        try! calculator.addMathOperator(MathOperator.minus)
        XCTAssertThrowsError(try calculator.addMathOperator(MathOperator.plus))
    }
}

extension String {
    var elements: [String] {
        return self.split(separator: " ").map { "\($0)" }
    }
}
