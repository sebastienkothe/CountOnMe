//
//  OperatorTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import XCTest
@testable import CountOnMe

class OperatorTestCase: XCTestCase {

    var `operator`: Operator!
    var textView: UITextView!

    override func setUp() {
        `operator` = Operator()
        textView = UITextView()
    }

    func testGivenSenderTagValueIs0_WhenSenderTagIsAddedToTheMethod_ThenTextViewMustContainPlusOperator() {

        for (key, `operator`) in `operator`.operatorSign {
            self.`operator`.addAnOperator(senderTag: key, textView: textView)
            XCTAssertEqual(textView.text, `operator`)
            textView.text = ""
        }
    }

    func testGivenSenderTagValueIs4_WhenSenderTagIsAddedToTheMethod_ThenTextViewMustNotContainAnOperator() {

        textView.text = "1"
        self.`operator`.addAnOperator(senderTag: 4, textView: textView)
        XCTAssertEqual(textView.text.count, 1)
    }
}
