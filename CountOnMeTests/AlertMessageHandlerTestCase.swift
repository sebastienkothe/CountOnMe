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

    override func setUp() {
        alertMessageHandler = AlertMessageHandler()
    }

    func testGivenThatAnInstanceHasBeenCreated_WhenTryingToAccessOfIt_ThenValueShouldBeNotNil() {
        XCTAssertNotNil(alertMessageHandler)
    }

}
