//
//  ForgotPasswordViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var sendLinkButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        sendLinkButton.backgroundColor = UIColor(hexFromString: "#124E61", alpha: 1)
        sendLinkButton.tintColor = UIColor(hexFromString: "#124E61", alpha: 1)
        sendLinkButton.layer.cornerRadius = 12
        
        let emailPadding = UIView(frame: CGRectMake(2, 2, 8, self.emailTextfield.frame.height))
        emailTextfield.leftView = emailPadding
        emailTextfield.leftViewMode = .always
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(hexFromString: "#124E61", alpha: 1)
    }
    
    @IBAction func handleResetPasswordButton(_ sender: Any) {
        let email = emailTextfield.text ?? ""
        
        spinner.startAnimating()
        AuthService.shared.forgotPassword(with: email) { error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                self.spinner.stopAnimating()
                return
            }
            
            self.view.makeToast("Reset password instruction has been sent to your email.")
            self.spinner.stopAnimating()
            self.emailTextfield.text = ""
        }
    }
}
