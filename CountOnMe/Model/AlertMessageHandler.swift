//
//  File.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 17/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation
import UIKit

final class AlertMessageHandler {

    deinit {
        print("An object has been destroyed")
    }

    internal func showAlertMessage(viewController: UIViewController, alertControllerIndex: Int) {
        currentViewController = viewController

        // Contains the desired UIAlertController instance
        let alertController = AlertControllerProvider().alertController[alertControllerIndex]

        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        viewController.present(alertController, animated: true, completion: nil)
    }

    // MARK: Private Properties

    private var currentViewController: UIViewController!

}
