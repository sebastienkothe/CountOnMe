//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 05/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
// swiftlint:disable trailing_whitespace
// swiftlint:disable force_try

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    var calculatorDelegateMock: CalculatorDelegateMock!
    var expressionToCalculateWithResult: [String: String]!
    
    override func setUp() {
        calculator = Calculator()
        calculatorDelegateMock = CalculatorDelegateMock()
        calculator.delegate = calculatorDelegateMock
        expressionToCalculateWithResult = [
            "666 * 888 - 333 / 1 + 8 * 999 - 5 / 4 * 555": " = 598373.25",
            "666 * 888 + 333 / 1 - 8 * 999 - 5 / 4 * 555": " = 583055.25",
            "666 * 888 - 333 / 1 - 8 * 999 - 5 / 4 * 555": " = 582389.25",
            "666 * 888 + 333 / 1 + 8 * 999 - 5 / 4 * 555": " = 599039.25",
            
            "-666 * 888 - 333 / 1 + 8 * 999 - 5 / 4 * 555": " = -584442.75"
        ]
    }
    
    func generateRandomOperator() -> MathOperator {
        let randomNumber = Int.random(in: 0...3)
        let randomOperatorGenerated = MathOperator.allCases[randomNumber]
        return randomOperatorGenerated
    }
    
    func generateRandomNumbersAsString() -> String {
        //       let randomNumber = Int.random(in: 0...3)
        //        return randomNumber
        return ""
    }
    
    func testGivenRandomExpressionFromDictionaryIsAdded_WhenTryingToCalculateIt_ThenResultShouldBeValueOfKey() {
        for expression in expressionToCalculateWithResult {
            calculator.addDigit(expression.key)
            
            try! calculator.handleTheExpressionToCalculate()
            
            XCTAssertEqual(calculatorDelegateMock.textToCompute, "\(expression.key)\(expression.value)")
        }
    }
    
    func testGivenOperatorIsMinus_WhenTextToComputeIsWorth_ThenTextToComputeShouldContainMinus() {
        let textToComputeCases = ["", "0", "=", "ERROR"]
        let operatorSign = MathOperator.minus
        
        for textToComputeCase in textToComputeCases {
            calculator.addDigit(textToComputeCase)
            try! calculator.addMathOperator(operatorSign)
            XCTAssertEqual(calculatorDelegateMock.textToCompute, " - ")
            calculator.resetOperation()
        }
    }
    
    func testGivenOperatorIsMinu_WhenTextToComputeIsWorth_ThenTextToComputeShouldContainMinus() {
        
        for senderTag in 0...3 {
            calculator.identifyTheOperatorFromThe(senderTag) { (result) in
                XCTAssertEqual(result, MathOperator.allCases[senderTag])
            }
            
        }
        
    }
}
