//
//  AlertMessageHandlerTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import XCTest
@testable import CountOnMe

class AlertMessageHandlerTestCase: XCTestCase {
    var alertMessageHandler: AlertMessageHandler!
    var viewController: CalculatorViewController!

    override func setUp() {
        alertMessageHandler = AlertMessageHandler()
        viewController = CalculatorViewController()
    }

    func testGivenThatAnInstanceHasBeenCreated_WhenTryingToAccessOfIt_ThenValueShouldBeNotNil() {
        XCTAssertNotNil(alertMessageHandler)
    }

    func testGivenTheArrayContainsFiveObjects_WhenTryingToAccessToEachOne_ThenNoErrorsShouldBeReturned() {
        let showAlertMessage = alertMessageHandler.showAlertMessage(viewController:alertControllerIndex:)
        for index in 0...4 {
            XCTAssertNoThrow(showAlertMessage(viewController, index))
        }
    }
}
