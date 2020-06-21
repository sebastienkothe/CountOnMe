//
//  String+Localized.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 20/06/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
