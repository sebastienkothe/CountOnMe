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
    func testGivenItemsContainsAllOperatorsAndANumber_WhenItemsIsAddedToTheMethod_ThenValueShouldBeFalse() {
        itemsToCheck = ["1", "+", "-", "*", "/", "="]

        for _ in itemsToCheck where itemsToCheck.count > 1 {

            XCTAssertFalse(expressionChecker.checkIfTheExpressionIsCorrect(itemsToCheck: itemsToCheck))
            itemsToCheck.removeLast()
        }

         XCTAssertTrue(expressionChecker.checkIfTheExpressionIsCorrect(itemsToCheck: itemsToCheck))
    }

    // Method tested : checkIfTheExpressionHasAResult(element: UITextView) -> Bool
    func testGivenTextViewContainsEqualOperator_WhenTextViewIsAddedToTheMethod_ThenValueShouldBeTrue() {

        textView.text.append("=")
        XCTAssertTrue(expressionChecker.checkIfTheExpressionHasAResult(element: textView))
        textView.text.removeAll()

        // And without value, the method must return false
        XCTAssertFalse(expressionChecker.checkIfTheExpressionHasAResult(element: textView))
    }

    // Method tested : checkTheExpressionLength(itemsToCheck: [String]) -> Bool
    func testGivenTheArrayContainsAnElement_WhenTheArrayIsAddedToTheMethod_ThenValueShouldBeFalse() {

        itemsToCheck = ["0"]

        while itemsToCheck.count < 3 {
            XCTAssertFalse(expressionChecker.checkTheExpressionLength(itemsToCheck: itemsToCheck))
            itemsToCheck.append("0")
        }

        // From three elements, the method must return true
        XCTAssertTrue(expressionChecker.checkTheExpressionLength(itemsToCheck: itemsToCheck))
    }

    // Method tested : checkTheExpressionConformity(textView: UITextView, elements: [String]) -> [Int]
    func testGivenTextViewContainsTheErrorMessage_WhenTextViewIsAddedToTheMethod_ThenResultShouldContainOne() {

        // textViewCases contains two error cases (1 & 3)
        let textViewCases = ["ERROR", "="]

        // itemsToCheck contains an error case (2)
        itemsToCheck = ["1", "+"]

        var result = [Int]()

        for index in 0..<2 {
        textView.text += textViewCases[index]
        result += expressionChecker.checkTheExpressionConformity(textView: textView, elements: itemsToCheck)
            textView.text = ""
        }

        XCTAssert(result.contains(1))
        XCTAssert(result.contains(2))
        XCTAssert(result.contains(3))
    }
}
