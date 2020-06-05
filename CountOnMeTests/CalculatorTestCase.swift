//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 05/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    
    override func setUp() {
        calculator = Calculator()
    }
    
    func generateRandomOperator() -> String {
        let characters = ["+", "-", "*", "/"]
        let randomNumber = Int.random(in: 0...3)
        let randomOperatorGenerated = characters[randomNumber]
        return randomOperatorGenerated
    }
    
    func testNoName() {
        
        calculator.textToCompute = "666 * 888 - 333 / 1 + 8 * 999 - 5 / 4 * 555"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("598373.25"))
        
        calculator.textToCompute = "-666 * 888 - 333 / 1 + 8 * 999 - 5 / 4 * 555"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("-584442.75"))
        
        calculator.textToCompute = "666 * 888 + 333 / 1 - 8 * 999 - 5 / 4 * 555"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("583055.25"))
        
        calculator.textToCompute = "666 * 888 + 333 / 1 + 8 * 999 - 5 / 4 * 555"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("599039.25"))
        
        calculator.textToCompute = "666 * 888 - 333 / 1 - 8 * 999 - 5 / 4 * 555"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("582389.25"))
        
        calculator.textToCompute = "999 - 888 / 333 * 1 / 8 - 999 - 5 * 4 * 555 * 999 - 888 / 333 * 1 / 8 - 999 - 5 * 4 * 555"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("-11100999.66666"))
        
        calculator.textToCompute = "9 - 3 / 2 * 9 / 2 - 3 - 5 / 3 - 3 * 9 + 1 * 6 + 3 * 4 + 8"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("-3.416666"))
        
        calculator.textToCompute = "-9 - 3 / 2 * 5604395 / 4921 - 3 - 5 / 100 * 2 + 3 * 4"
        try! calculator.handleTheExpressionToCalculate()
        XCTAssertTrue(calculator.textToCompute.contains("-1708.40979"))
    }
}
