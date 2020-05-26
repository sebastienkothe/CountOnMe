//
//  CalculationTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 20/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculationTestCase: XCTestCase {
    var calculation: Calculation!
    var `operator`: Operator!

    override func setUp() {
        calculation = Calculation()
        `operator` = Operator()
    }

    func testGivenOperandsAreWorth1AndOperatorIsPlus_WhenExpressionIsAddedToTheMethod_ThenResultShouldBe2() {

        let expectedResult = [2, 0, 1, 1]

        for (key, `operator`) in `operator`.operatorSign {
            let operatorWithoutWhiteSpace = `operator`.trimmingCharacters(in: .whitespaces)
            guard let result = calculation.performTheOperation(operatorWithoutWhiteSpace, 1, 1) else { return }
            XCTAssertEqual(result, expectedResult[key])
        }
    }

    func testGivenOperandsAreWorth1AndOperatorIsNil_WhenExpressionIsAddedToTheMethod_ThenResultShouldBeNil() {

            let `operator` = ""
            let result = calculation.performTheOperation(`operator`, 1, 1)
            XCTAssertNil(result)
        }
    }
