//
//  CalculatorDelegateMock.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 07/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

class CalculatorDelegateMock: CalculatorDelegate {
    var textToCompute = ""

    func textToComputeDidChange(textToCompute: String) {
        self.textToCompute = textToCompute
    }
}
