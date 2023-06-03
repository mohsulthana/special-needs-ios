//
//  AddStudentViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 08/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: PrimaryFilledButton!
    @IBOutlet weak var studentNameTextfield: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Student"
    }
    
    @IBAction func handleAddBtn(_ sender: Any) {
        let name = studentNameTextfield.text
        
        if let name, !name.isEmpty {
            self.loadingIndicator.startAnimating()
            StudentService.shared.addNewStudent(name: name) { bool, error in
                if let error {
                    self.view.makeToast(error)
                    self.loadingIndicator.stopAnimating()
                    return
                }
                
                self.dismiss(animated: true) {
                    self.view.makeToast("Student has been added")
                }
                self.loadingIndicator.stopAnimating()
            }
        }
        
        view.makeToast("Your should fill the student name")
        dismiss(animated: true)
        return
    }
}
