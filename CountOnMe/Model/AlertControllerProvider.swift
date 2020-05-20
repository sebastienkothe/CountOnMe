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

   internal let alertController = [

    UIAlertController(title: "Error", message: "An operator already exists", preferredStyle: .alert),

    UIAlertController(title: "Error", message: "Enter a correct expression", preferredStyle: .alert),

    UIAlertController(title: "Error", message: "Start a new calculation", preferredStyle: .alert),

    ]
}
