//
//  ExpressionCheckerTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 20/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import XCTest
@testable import CountOnMe

class ExpressionCheckerTestCase: XCTestCase {
    var expressionChecker: ExpressionChecker!
    var itemsToCheck: [String]!
    var textView: UITextView!

    override func setUp() {
        expressionChecker = ExpressionChecker()
        itemsToCheck = [String]()
        textView = UITextView()
    }

    // Method tested : checkIfTheExpressionIsCorrect(itemsToCheck: [String]) -> Bool
    func testGivenItemsToCheckContainsAllOperatorsAndANumber_WhenItemsIsAddedToTheMethod_ThenValueShouldBeFalse() {
        itemsToCheck = ["1", "+", "-", "*", "/", "="]

        for _ in itemsToCheck where itemsToCheck.count > 1 {

            XCTAssertFalse(expressionChecker.checkIfTheExpressionIsCorrect(itemsToCheck: itemsToCheck))
            itemsToCheck.removeLast()
        }

         XCTAssertTrue(expressionChecker.checkIfTheExpressionIsCorrect(itemsToCheck: itemsToCheck))
    }

    // Method tested : checkIfTheExpressionHasAResult(element: UITextView) -> Bool
    func testGivenElementContainsEqualOperator_WhenElementIsAddedToTheMethod_ThenValueShouldBeTrue() {
        textView.text.append("=")
        XCTAssertTrue(expressionChecker.checkIfTheExpressionHasAResult(element: textView))

    }

    // Method tested : checkTheExpressionLength(itemsToCheck: [String]) -> Bool
    func testGivenItemsToCheckContainsThreeNumbersAndLess_WhenItemsIsAddedToTheMethod_ThenValueShouldBeTrue() {

        itemsToCheck = ["0", "+"]

        for _ in itemsToCheck where itemsToCheck.count < 3 {
            XCTAssertFalse(expressionChecker.checkTheExpressionLength(itemsToCheck: itemsToCheck))
            itemsToCheck.append("0")
        }

        XCTAssertTrue(expressionChecker.checkTheExpressionLength(itemsToCheck: itemsToCheck))

    }
}
