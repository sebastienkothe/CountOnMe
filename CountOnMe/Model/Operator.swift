//
//  Operator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

struct Operator {
    let operatorSign = [" + ", " - ", " * ", " / "]
    let equalSign = " = "
    
    /// The operator tag that indicates which operator has been selected
    static var operatorTag = 0
    
    var operatorSignProvider: String {
        
        switch Operator.operatorTag {
        case OperatorTagProvider.addition.rawValue:
            return operatorSign[OperatorTagProvider.addition.rawValue]
        case OperatorTagProvider.subtraction.rawValue:
            return operatorSign[OperatorTagProvider.subtraction.rawValue]
        case OperatorTagProvider.multiplication.rawValue:
            return operatorSign[OperatorTagProvider.multiplication.rawValue]
        case OperatorTagProvider.division.rawValue:
            return operatorSign[OperatorTagProvider.division.rawValue]
        default:
            return ""
        }
        
       
    }
}


