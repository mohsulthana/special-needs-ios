//
//  ProfileViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 11/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.isHidden = false
        spinner.startAnimating()
        AuthService.shared.fetchUser { user, error in
            guard let user else {
                return
            }
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.username.text = user.username
            self.email.text = user.email
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func handleSignout(_ sender: Any) {
        AuthService.shared.signOut { error in
            if let error {
                print("error")
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectGradeVC") as! SelectGradeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
