//
//  AlertControllerProvider.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 18/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation
import UIKit

struct AlertControllerProvider {
    
    // MARK: Internal properties
   internal let alertController = [

    UIAlertController(title: "Error", message: "An operator already exists", preferredStyle: .alert),

    UIAlertController(title: "Error", message: "Start a new calculation", preferredStyle: .alert),

    UIAlertController(title: "Error", message: "Not enough elements", preferredStyle: .alert),

    UIAlertController(title: "Error", message: "Equal operator already exists", preferredStyle: .alert),

    UIAlertController(title: "Error", message: "Invalid expression", preferredStyle: .alert)

    ]
}
