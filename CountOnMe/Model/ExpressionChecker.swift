//
//  ExpressionChecker.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 20/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation
import UIKit

final class ExpressionChecker {

    deinit {
        print("An object has been destroyed")
    }

    // MARK: - Internal methods

    // Error check computed variables
    internal func checkIfTheExpressionIsCorrect(itemsToCheck: [String]) -> Bool {
        let `operator` = Operator()

        for (_, `operator`) in `operator`.operatorSign where itemsToCheck.last == `operator`.trimmingCharacters(in: .whitespaces) || itemsToCheck.last == "=" {
            return false
        }

        return true
    }

    internal func checkIfTheExpressionHasAResult(element: UITextView) -> Bool {
        return element.text.firstIndex(of: "=") != nil
    }

    internal func checkIfTheExpressionHaveEnoughElements(itemsToCheck: [String]) -> Bool {
        return itemsToCheck.count >= 3
    }
}
