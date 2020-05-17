//
//  File.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation
import UIKit

class AlertMessageHandler {

    func showAlertMessage(viewController: UIViewController) {
        currentViewController = viewController

        let alertViewController = UIAlertController(title: "Zero!", message: "An operator already exists !", preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    //MARK: Private Properties
    
    private var currentViewController: UIViewController!
    
}
