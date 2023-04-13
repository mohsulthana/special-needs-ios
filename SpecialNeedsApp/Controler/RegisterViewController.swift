//
//  RegisterViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var fullnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordConfirmationTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        registerButton.backgroundColor = UIColor(hexFromString: "#124E61", alpha: 1)
        registerButton.tintColor = UIColor(hexFromString: "#124E61", alpha: 1)
        registerButton.layer.cornerRadius = 12
        
        let fullnamePadding = UIView(frame: CGRectMake(2, 2, 8, self.fullnameTextfield.frame.height))
        fullnameTextfield.leftView = fullnamePadding
        fullnameTextfield.leftViewMode = .always
        
        let emailPadding = UIView(frame: CGRectMake(2, 2, 8, self.emailTextfield.frame.height))
        emailTextfield.leftView = emailPadding
        emailTextfield.leftViewMode = .always
        
        let passwordPadding = UIView(frame: CGRectMake(2, 2, 8, self.passwordTextfield.frame.height))
        passwordTextfield.leftView = passwordPadding
        passwordTextfield.leftViewMode = .always
        
        let confirmationPasswordPadding = UIView(frame: CGRectMake(2, 2, 8, self.passwordConfirmationTextfield.frame.height))
        passwordConfirmationTextfield.leftView = confirmationPasswordPadding
        passwordConfirmationTextfield.leftViewMode = .always
    }
    
    @IBAction func handleRegisterButton(_ sender: Any) {
        let fullname = fullnameTextfield.text ?? ""
        let email = emailTextfield.text ?? ""
        let passowrd = passwordTextfield.text ?? ""
        
        let userRequest = RegisterUserRequest(fullname: fullname, email: email, password: passowrd)
        

        spinner.startAnimating()
        AuthService.shared.registerUser(with: userRequest) { isRegistered, error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                self.spinner.stopAnimating()
                return
            }
            
            if isRegistered {
                self.view.makeToast("User registered successfully")
                self.spinner.stopAnimating()
            }
        }
    }
    
}
