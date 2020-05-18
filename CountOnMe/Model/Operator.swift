//
//  Operator.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

struct Operator {
    let operatorSign = ["+", "-", "=", "x", "/"]
    var operatorTag: [Int] = []
    
    var operatorSignProvider: String {
        var operatorSignSelected = ""
        
        for operatorTag in operatorTag {
            
            switch operatorTag {
            case OperatorTagProvider.addition.rawValue:
                operatorSignSelected = operatorSign[OperatorTagProvider.addition.rawValue]
            case OperatorTagProvider.subtraction.rawValue:
                operatorSignSelected = operatorSign[OperatorTagProvider.subtraction.rawValue]
            case OperatorTagProvider.equal.rawValue:
                operatorSignSelected = operatorSign[OperatorTagProvider.equal.rawValue]
            case OperatorTagProvider.multiplication.rawValue:
                operatorSignSelected = operatorSign[OperatorTagProvider.multiplication.rawValue]
            case OperatorTagProvider.division.rawValue:
                operatorSignSelected = operatorSign[OperatorTagProvider.division.rawValue]
            default:
                break
            }
            
        }
        return operatorSignSelected
    }
}


