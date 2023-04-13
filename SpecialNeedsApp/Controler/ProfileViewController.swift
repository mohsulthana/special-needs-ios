//
//  ProfileViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Toast
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.startAnimating()
        AuthService.shared.fetchUser { user, error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                self.spinner.stopAnimating()
                return
            }

            guard let user else {
                self.view.makeToast("Error happened. See log for more info")
                self.spinner.stopAnimating()
                print(error?.localizedDescription ?? "")
                return
            }

            self.nameLabel.text = user.username
            self.emailLabel.text = user.email
            self.spinner.stopAnimating()
        }
    }

    @IBAction func handleSignOut(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
            AuthService.shared.signOut { error in
                if let error {
                    self.view.makeToast(error.localizedDescription)

                    return
                }

                self.view.makeToast("Successfully signed out")

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Base_NC") as! UINavigationController
                self.view.window?.rootViewController = viewController
                self.view.window?.makeKeyAndVisible()
            }
        }))

        present(alert, animated: true, completion: nil)
    }
}
