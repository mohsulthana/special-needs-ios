//
//  AddGradeViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 19/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class AddGradeViewController: UIViewController {

    @IBOutlet weak var gradeName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissPage))
        backButton.tintColor = UIColor(hexFromString: "#124E61", alpha: 1)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dismissPage() {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func handleNewGrade(_ sender: Any) {
        let gradeName = gradeName.text ?? ""
        let subjects: [String: [String]] = [gradeName: [""]]
        
        let grade: NewGradeRequest = NewGradeRequest(name: gradeName, subjects: subjects)
        
        GradeService.shared.addNewGrade(with: grade) { isCreated, error in
            if let error {
                self.view.makeToast(error)
                return
            }
            
            if isCreated != nil {
                self.view.makeToast("Grade was created")
                self.dismissPage()
                return
            }
        }
    }
}
