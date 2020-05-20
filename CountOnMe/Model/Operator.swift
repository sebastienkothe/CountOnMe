//
//  Operator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

struct Operator {

    // MARK: - Internal properties
    internal let operatorSign = [0: " + ", 1: " - ", 2: " * ", 3: " / "]

    /// The operator tag that indicates which operator has been selected
    internal static var operatorTag = 0

    internal var operatorSignProvider: String? {

        for (key, _) in operatorSign where Operator.operatorTag == key {
            return operatorSign[key]
        }

        return nil
    }

    // MARK: - Private properties
    private let equalSign = " = "

}
