//
//  AlertControllerProviderTestCase.swift
//  CountOnMeTests
//
//  Created by Sébastien Kothé on 20/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import XCTest
@testable import CountOnMe

class AlertControllerProviderTestCase: XCTestCase {

    var alertControllerProvider: AlertControllerProvider!

    override func setUp() {
        alertControllerProvider = AlertControllerProvider()
    }

    func testGivenThatAnInstanceHasBeenCreated_WhenTryingToAccessOfIt_ThenValueShouldBeNotNil() {
        XCTAssertNotNil(alertControllerProvider)
    }
}
