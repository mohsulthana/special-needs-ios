//
//  AddStudentProgressViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class AddStudentProgressViewController: UIViewController {
    
    @IBOutlet weak var datepickerTextfield: CustomTextField!
    @IBOutlet weak var scoreTextfield: UITextField!
    var student: StudentsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date() - 1
        datepickerTextfield.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        datepickerTextfield.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/dd/yyyy"
        return formatter.string(from: date)
    }
    
    private func stringDateToTimestamp(date: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.date(from: date)?.timeIntervalSince1970 ?? 0.0
    }
    
    @IBAction func handleAddProgressBtn(_ sender: Any) {
        guard datepickerTextfield.text != "" && scoreTextfield.text != "" else {
            self.view.makeToast("Please fill all required field")
            return
        }
        
        if let date = datepickerTextfield.text, let score = scoreTextfield.text {
            let timestampDate = stringDateToTimestamp(date: date)
            let request: AddProgressRequest = AddProgressRequest(score: Int(score) ?? 0, date: timestampDate, documentID: student?.documentID ?? "", progressID: student?.progress.documentID ?? "")
            
            StudentService.shared.addProgress(request: request) { error in
                if let error {
                    self.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}
