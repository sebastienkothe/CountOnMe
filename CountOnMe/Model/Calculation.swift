//
//  Calculation.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 20/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

final class Calculation {

    // MARK: - Internal methods
    internal func performTheOperation(_ operatorRecovered: String, _ operandLeft: Int, _ operandRight: Int) -> Int? {
        let result: Int?

        switch operatorRecovered {
        case "+": result = operandLeft + operandRight
        case "-": result = operandLeft - operandRight
        case "*": result = operandLeft * operandRight
        case "/": result = operandLeft / operandRight

        default:
            return nil
        }

        return result
    }

}
