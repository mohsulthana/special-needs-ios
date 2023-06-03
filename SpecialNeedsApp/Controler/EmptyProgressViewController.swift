//
//  EmptyProgressViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 03/06/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class EmptyProgressViewController: UIViewController {

    @IBOutlet weak var addProgressBtn: PrimaryFilledButton!
    var student: StudentsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleAddProgressBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddStudentProgress_VC") as! AddStudentProgressViewController
        vc.student = student
        navigationController?.pushViewController(vc, animated: true)
    }
}
