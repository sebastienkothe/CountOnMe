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

    deinit {}

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

    internal func checkTheExpressionLength(itemsToCheck: [String]) -> Bool {
        return itemsToCheck.count >= 3
    }

    internal func checkTheExpressionConformity(textView: UITextView, elements: [String]) -> [Int] {
        let expressionChecker = ExpressionChecker()
        var errorsFound = [Int]()

        if textView.text == "ERROR" { errorsFound.append(1) }

        if !expressionChecker.checkTheExpressionLength(itemsToCheck: elements) { errorsFound.append(2) }

        if expressionChecker.checkIfTheExpressionHasAResult(element: textView) { errorsFound.append(3) }

        if !expressionChecker.checkIfTheExpressionIsCorrect(itemsToCheck: elements) { errorsFound.append(4) }

        return errorsFound
    }

}
