//
//  EmptyStudentDetailViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 03/06/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class EmptyStudentDetailViewController: UIViewController {
    var students: StudentsModel?
    @IBOutlet var setupTargetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleSetupTargetBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddStudentTarget_VC") as! AddStudentTargetViewController
        vc.students = students
        navigationController?.pushViewController(vc, animated: true)
    }
}

