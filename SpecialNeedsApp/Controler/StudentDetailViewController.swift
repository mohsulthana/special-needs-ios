//
//  StudentDetailViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 08/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Charts
import UIKit

class StudentDetailViewController: UIViewController {
    @IBOutlet var studentChart: LineChartView!
    @IBOutlet var progressTableView: UITableView!
    @IBOutlet var rootView: UIView!
    var students: StudentsModel?
    var progress: ProgressModel?

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentSubjectLabel: UILabel!
    @IBOutlet weak var studentGoalLabel: UILabel!
    @IBOutlet weak var studentGradeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    var numbers: [Double] = []
    var date: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let student = students else { return }
        navigationItem.title = student.name
        studentNameLabel.text = student.name
        studentGoalLabel.text = student.progress.goal
        studentGradeLabel.text = student.progress.grade
        studentSubjectLabel.text = student.progress.subject
        endDateLabel.text = "Ended on \(timestampToFullDateString(timestamp: Double(student.progress.endDate ?? 0)))"
        
        progressTableView.delegate = self
        progressTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchStudentProgress()
    }

    private func bindProgressData() {
        self.numbers = []
        self.date = []
        guard let progress = progress else { return }

        progress.data?.forEach({ data in
            self.date.append(data.time ?? 0)
            self.numbers.append(Double(data.score ?? 0))
            self.progressTableView.reloadData()
        })
    }
    
    private func fetchStudentProgress() {
        StudentService.shared.fetchStudentProgress(documentID: students?.documentID ?? "", progressID: students?.progress.documentID ?? "") { progress, error in
            if error != nil {
                print("Error")
            }
            
            self.progress = progress
            
            DispatchQueue.main.async {
                self.bindProgressData()
                self.updateGraph()
            }
        }
    }

    @IBAction func handleAddProgressBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddStudentTarget_VC") as! AddStudentTargetViewController
        vc.students = students
        navigationController?.pushViewController(vc, animated: true)
    }

    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            lineChartEntry.append(ChartDataEntry(x: Double(i), y: numbers[i]))
        }

        let lineChartDataSet = LineChartDataSet(entries: lineChartEntry, label: "Date")
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.setColor(UIColor.black)
        lineChartDataSet.setCircleColor(UIColor.black) // our circle will be dark red
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 3.0 // the radius of the node circle
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fillColor = UIColor.black
        lineChartDataSet.highlightColor = UIColor.white
        lineChartDataSet.drawCircleHoleEnabled = true
        lineChartDataSet.colors = [NSUIColor.blue] // Sets the colour to blue

        var dataSets = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)

        var dateString: [String] = []
        date.forEach { timestamp in
            let convertedDate = timestampToShortDateString(timestamp: Double(timestamp))
            dateString.append(convertedDate)
        }

        let lineChartData = LineChartData(dataSets: dataSets)
        studentChart.data = lineChartData
        studentChart.rightAxis.enabled = false
        studentChart.xAxis.labelPosition = .bottom
        studentChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateString)
        studentChart.xAxis.granularityEnabled = true
        studentChart.xAxis.granularity = 1.0
        studentChart.xAxis.avoidFirstLastClippingEnabled = true
        studentChart.noDataText = "No data available"
        studentChart.noDataTextColor = .darkText
        studentChart.noDataTextAlignment = .center

        studentChart.chartDescription.text = "\(students?.name ?? "") progress" // Here we set the description for the graph
    }

    private func timestampToFullDateString(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.current.abbreviation() ?? "CET" // get current TimeZone abbreviation or set to CET
        dateFormatter.timeZone = TimeZone(abbreviation: timezone) // Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yyyy" // Specify your format that you want
        return dateFormatter.string(from: date)
    }

    private func timestampToShortDateString(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.current.abbreviation() ?? "CET" // get current TimeZone abbreviation or set to CET
        dateFormatter.timeZone = TimeZone(abbreviation: timezone) // Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd" // Specify your format that you want
        return dateFormatter.string(from: date)
    }
}

extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberObjects = numbers.count + 1
        if numberObjects == 1 {
            tableView.setEmptyView(title: "No data recorded", message: "Add some progress to show the data on this page")
            numberObjects = 0
        } else {
            tableView.restore()
        }
        return numberObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "targetCellId", for: indexPath)

        if indexPath.row == numbers.count {
            cell.textLabel?.text = "+ Add New Progress"
            cell.textLabel?.textColor = .primaryColor
            cell.detailTextLabel?.text = ""
        } else {
            let dateLabel = timestampToFullDateString(timestamp: Double(date[indexPath.row]))
            let progressLabel = numbers[indexPath.row]

            cell.textLabel?.text = "\(dateLabel)"
            cell.detailTextLabel?.text = "\(progressLabel)"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == numbers.count {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddStudentProgress_VC") as! AddStudentProgressViewController
            vc.student = students
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Hello world")
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        print("Hello world")
    }
}
