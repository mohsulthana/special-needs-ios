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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var student: StudentsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreTextfield.keyboardType = .numberPad
        scoreTextfield.delegate = self
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date() - 1
        datepickerTextfield.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        datepickerTextfield.text = timestampToShortDateString(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.string(from: date)
    }
    
    private func stringDateToTimestamp(date: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.date(from: date)?.timeIntervalSince1970 ?? 0.0
    }
    
    private func timestampToShortDateString(date: Date) -> String {
        let timestamp = date.timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.current.abbreviation() ?? "CET" // get current TimeZone abbreviation or set to CET
        dateFormatter.timeZone = TimeZone(abbreviation: timezone) // Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/YYYY" // Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    @IBAction func handleAddProgressBtn(_ sender: Any) {
        guard datepickerTextfield.text != "" && scoreTextfield.text != "" else {
            self.view.makeToast("Please fill all required field")
            return
        }

        loadingIndicator.startAnimating()

        if let date = datepickerTextfield.text, let score = scoreTextfield.text {
            let timestampDate = stringDateToTimestamp(date: date)
            let request: AddProgressRequest = AddProgressRequest(score: Int(score) ?? 0, date: timestampDate, documentID: student?.documentID ?? "", progressID: student?.progress.documentID ?? "")

            StudentService.shared.addProgress(request: request) { [weak self] error in
                if let error {
                    self?.view.makeToast(error.localizedDescription)
                    self?.loadingIndicator.stopAnimating()
                    return
                }
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "StudentDetail_VC") as! StudentDetailViewController
                vc.students = self?.student
                
                self?.navigationController?.popToViewController(of: StudentViewController.self, animated: true)
                self?.navigationController?.pushViewController(vc, animated: true)
                
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.view.makeToast("Successfully added progress")
                }
            }
        }
    }
}

extension AddStudentProgressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == scoreTextfield {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
            if let num = Int(newText), num >= 0 && num <= 100 {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
}
