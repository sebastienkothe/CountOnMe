//
//  MathOperator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

enum MathOperator: CaseIterable {
    case plus
    case minus
    case multiplication
    case division

    var symbol: String {
        switch self {
        case .plus: return " + "
        case .minus: return " - "
        case .multiplication: return " * "
        case .division: return " / "
        }
    }
}
