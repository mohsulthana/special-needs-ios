//
//  ProfileViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit
import Toast

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthService.shared.fetchUser { user, error in
            if let error {
                self.view.makeToast("Error happened. See log for more info")
                print(error)
                return
            }
            
            guard let user else {
                self.view.makeToast("Error happened. See log for more info")
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.nameLabel.text = user.username
            self.emailLabel.text = user.email
        }
    }
    
    @IBAction func handleSignOut(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (_) in
            AuthService.shared.signOut { error in
                if let error {
                    self.view.makeToast("Error happened. See log for more info")
                    print(error)
                    return
                }
                
                let SelectGradeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectGradeVC")
                self.navigationController?.pushViewController(SelectGradeVC, animated: true)
                
                self.view.makeToast("Successfully signed out")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
