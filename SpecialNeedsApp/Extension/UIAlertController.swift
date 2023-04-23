//
//  UIAlertController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 23/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

extension UIAlertController {
    func isNotEmpty(_ text: String) -> Bool {
        return !text.isEmpty
    }

    @objc func textValidateEmptyText() {
        if let email = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = isNotEmpty(email)
        }
    }
}
