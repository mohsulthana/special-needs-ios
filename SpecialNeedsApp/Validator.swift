//
//  Validator.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 12/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

class Validator {
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
}
