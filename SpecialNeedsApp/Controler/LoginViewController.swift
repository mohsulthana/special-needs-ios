//
//  LoginViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 11/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }

    func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissPage))
        backButton.tintColor = UIColor.primaryColor
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func dismissPage() {
        navigationController?.dismiss(animated: true)
    }

    @IBAction func handleLoginButton(_ sender: Any) {
        let email = emailTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""

        let loginRequest = LoginUserRequest(email: email, password: password)
        spinner.startAnimating()

        AuthService.shared.loginUser(with: loginRequest) { wasLoggedIn, error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                self.spinner.stopAnimating()
                return
            }

            if wasLoggedIn {
                DispatchQueue.main.async {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabbarStoryboard") as! UITabBarController
                    self.view.window?.rootViewController = viewController
                    self.view.window?.makeKeyAndVisible()
                    self.view.makeToast("Logged In Successfully")
                    self.spinner.stopAnimating()
                }
            }
        }
    }
}
