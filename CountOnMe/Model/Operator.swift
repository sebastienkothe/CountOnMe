//
//  Operator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation
import UIKit

struct Operator {

    // MARK: - Internal properties
    internal let operatorSign = [0: " + ", 1: " - ", 2: " * ", 3: " / "]

    // MARK: - Internal methods
    internal func addAnOperator(senderTag: Int, textView: UITextView) {
        var operatorSelected: String?

        for (key, _) in operatorSign where senderTag == key {
           operatorSelected = operatorSign[key]
        }

        guard let operatorSelectedByUser = operatorSelected else { return }

        textView.text.append(operatorSelectedByUser)
    }

    // MARK: - Private properties
    private let equalSign = " = "

}
