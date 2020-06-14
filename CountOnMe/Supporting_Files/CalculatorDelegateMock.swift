//
//  CalculatorDelegateMock.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 07/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

class CalculatorDelegateMock: CalculatorDelegate {
    var errorRecovered: CalculatorError?
    func didProduceError(_ error: CalculatorError) {
        errorRecovered = error
    }
    
    var textToCompute = ""
    func didChangeOperation(_ operation: String) {
        self.textToCompute = operation
    }
}
