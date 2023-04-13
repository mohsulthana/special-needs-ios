//
//  ForgotPasswordViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func handleResetPasswordButton(_ sender: Any) {
        let email = emailTextfield.text ?? ""
        AuthService.shared.forgotPassword(with: email) { error in
            if let error {
                print(error)
                return
            }
        }
    }
}
