//
//  AddStudentProgressViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 08/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import iOSDropDown
import UIKit

class AddStudentTargetViewController: UIViewController {
    var students: StudentsModel?

    @IBOutlet var nameText: UILabel!
    @IBOutlet var gradeTextfield: UITextField!
    @IBOutlet var goalTextfield: CustomTextField!
    @IBOutlet var subjectTextfield: CustomTextField!
    @IBOutlet var timeTextfield: UITextField!
    @IBOutlet var endDateTextfield: UITextField!
    @IBOutlet var addBtn: PrimaryFilledButton!
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var gradesArr: [String] = []
    var subjectsArr: [String] = []
    var goalsArr: [String] = []
    var timeIntervalArr: [String] = ["Daily", "Weekly", "Monthly"]

    var gradePickerView = UIPickerView()
    var subjectPickerView = UIPickerView()
    var goalPickerView = UIPickerView()
    var intervalPickerView = UIPickerView()
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date() - 1
        endDateTextfield.inputView = datePicker

        guard let studentName = students else { return }
        studentNameLabel.text = studentName.name

        intervalPickerView.delegate = self
        intervalPickerView.dataSource = self

        gradePickerView.delegate = self
        gradePickerView.dataSource = self

        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self

        goalPickerView.delegate = self
        goalPickerView.dataSource = self

        gradeTextfield.inputView = gradePickerView
        subjectTextfield.inputView = subjectPickerView
        goalTextfield.inputView = goalPickerView
        timeTextfield.inputView = intervalPickerView

        goalTextfield.isEnabled = subjectTextfield.text != ""

        fetchGradesData()
    }

    @objc func dateChanged(datePicker: UIDatePicker) {
        endDateTextfield.text = timestampToShortDateString(date: datePicker.date)
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
    
    private func fetchGradesData() {
        gradesArr = []
        GradeService.shared.fetchGrades { grades, error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                return
            }

            guard let grades else { return }

            for grade in grades {
                self.gradesArr.append(grade.grade)
            }
        }
    }

    private func bindSubjectsData() {
        subjectsArr = []
        GradeService.shared.fetchGrades { grades, error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                return
            }

            guard let grades else { return }

            let grade: Grades = grades.filter { $0.grade == self.gradeTextfield.text }.first ?? Grades(documentID: "Empty", grade: "Empty", subjects: nil)

            if let subjects = grade.subjects?.array {
                for subject in subjects {
                    self.subjectsArr.append(subject.name?.rawValue ?? "")
                }
            }
        }
    }

    private func bindGoalsData() {
        goalsArr = []
        GradeService.shared.fetchGrades { grades, error in
            if let error {
                self.view.makeToast(error.localizedDescription)
                return
            }

            guard let grades else { return }

            let grade: Grades = grades.filter { $0.grade == self.gradeTextfield.text }.first ?? Grades(documentID: "Empty", grade: "Empty", subjects: nil)

            if let subjects = grade.subjects?.array {
                let subject: SubjectGoals = subjects.filter { $0.name?.rawValue == self.subjectTextfield.text }.first ?? SubjectGoals(name: nil, goals: [])
                for goal in subject.goals {
                    self.goalsArr.append(goal)
                }
            }
            self.goalTextfield.isEnabled = true
        }
    }

    @IBAction func handleAddData(_ sender: Any) {
        guard gradeTextfield.text != "" && subjectTextfield.text != "" && goalTextfield.text != "" && timeTextfield.text != "" && endDateTextfield.text != "" else {
            view.makeToast("Please fill all required information")
            return
        }
        
        loadingIndicator.startAnimating()

        if let grade = gradeTextfield.text, let subject = subjectTextfield.text, let goal = goalTextfield.text, let interval = timeTextfield.text, let endDate = endDateTextfield.text {
            let endDateTimestamp = datePicker.date.timeIntervalSince1970
            let target = AddStudentTargetRequest(grade: grade, subject: subject, goal: goal, interval: interval, endDate: endDateTimestamp)
            StudentService.shared.addStudentTarget(target: target, documentID: students?.documentID ?? "") { progressID, error in
                if error != nil {
                    self.view.makeToast("Internal server error when adding student target.")
                    self.loadingIndicator.stopAnimating()
                    return
                }
                
                if progressID != nil {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(identifier: "EmptyProgress_VC") as! EmptyProgressViewController
                    guard let students = self.students else { return }
                    let student: StudentsModel = StudentsModel(name: students.name, progress: ProgressModel(goal: students.progress.goal, grade: students.progress.grade, subject: students.progress.subject, data: students.progress.data, documentID: progressID, endDate: students.progress.endDate, interval: students.progress.interval), documentID: students.documentID)
                    vc.student = student
                    
                    self.navigationController?.popToViewController(of: StudentViewController.self, animated: true)
                    self.view.makeToast("Successfully set up student target")
                    self.loadingIndicator.stopAnimating()
                    
                    return
                }
            }
        }
    }
}

extension AddStudentTargetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == goalPickerView {
            return goalsArr.count
        } else if pickerView == subjectPickerView {
            return subjectsArr.count
        } else if pickerView == gradePickerView {
            return gradesArr.count
        } else if pickerView == intervalPickerView {
            return timeIntervalArr.count
        }

        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == goalPickerView {
            return goalsArr[row]
        } else if pickerView == subjectPickerView {
            return subjectsArr[row]
        } else if pickerView == gradePickerView {
            return gradesArr[row]
        } else if pickerView == intervalPickerView {
            return timeIntervalArr[row]
        }

        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == goalPickerView {
            goalTextfield.text = goalsArr[row]
        } else if pickerView == subjectPickerView {
            subjectTextfield.text = subjectsArr[row]
            bindGoalsData()
        } else if pickerView == gradePickerView {
            gradeTextfield.text = gradesArr[row]
            bindSubjectsData()
        } else if pickerView == intervalPickerView {
            timeTextfield.text = timeIntervalArr[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == goalPickerView {
            let label = UILabel(frame: CGRectMake(0, 0, 300, 44))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 3
            label.text = goalsArr[row]
            label.sizeToFit()
            return label
        } else if pickerView == subjectPickerView {
            let label = UILabel(frame: CGRectMake(0, 0, 300, 44))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.text = subjectsArr[row]
            label.sizeToFit()
            return label
        } else if pickerView == gradePickerView {
            let label = UILabel(frame: CGRectMake(0, 0, 300, 44))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.text = gradesArr[row]
            label.sizeToFit()
            return label
        } else {
            let label = UILabel(frame: CGRectMake(0, 0, 300, 44))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.text = timeIntervalArr[row]
            label.sizeToFit()
            return label
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == goalPickerView {
            return 80
        }

        return 30
    }
}
