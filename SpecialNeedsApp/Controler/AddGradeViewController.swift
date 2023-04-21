//
//  AddGradeViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 19/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class AddGradeViewController: UIViewController {

    @IBOutlet weak var goalsName: UITextField!
    var grade: [String]!
    var documentID: String?
    var subjectName: String?
    var goals: [String]?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    
    @IBAction func handleNewGoals(_ sender: Any) {
        let goalsName = goalsName.text ?? ""
        let id = documentID ?? ""
        let subject = subjectName ?? ""
        
        let request = NewGoalRequest(documentID: id, goal: goalsName, subjectName: subject)
        
        spinner.startAnimating()
        GoalService.shared.createNewGoals(with: request) { error in
            if error != nil {
                self.view.makeToast("Error")
                return
            }
            
            self.view.makeToast("A new goals has been added")
        }
        self.dismissPage()
    }
}
