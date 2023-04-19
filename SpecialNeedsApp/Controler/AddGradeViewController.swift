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
    
    @IBAction func handleNewGoals(_ sender: Any) {
        let goalsName = goalsName.text ?? ""
        
        GoalService.shared.createNewGoals(id: documentID ?? "", key: subjectName ?? "", value: goalsName) { error in
            if let error {
                self.view.makeToast("Error")
                return
            }
        }
    }
}
