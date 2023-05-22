//
//  StudentDetailViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 08/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit
import Charts

class StudentDetailViewController: UIViewController {
    
    @IBOutlet weak var studentChart: LineChartView!
    @IBOutlet weak var addTargetBtn: UIButton!
    @IBOutlet weak var progressTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyViewContainer: UIView!
    @IBOutlet weak var rootView: UIView!
    var students: StudentsModel?
    
    var numbers : [Double] = []
    var date: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = students else { return }
        navigationItem.title = student.name
        bindProgressData()
        updateGraph()
        // TODO: Resize RootView
        emptyViewContainer.isHidden = student.progress.goal == nil ? false : true
        addTargetBtn.isHidden = student.progress.goal == nil ? false : true
        emptyLabel.isHidden = student.progress.goal == nil ? false : true
        emptyLabel.text = "No target added for this student. Please add one."
        emptyLabel.numberOfLines = 0
        emptyLabel.lineBreakMode = .byTruncatingMiddle
        emptyLabel.textColor = .secondaryLabel
        
        progressTableView.delegate = self
        progressTableView.dataSource = self
        
        studentChart.isHidden = student.progress.goal == nil ? true : false
        progressTableView.isHidden = student.progress.goal == nil ? true : false
    }
    
    private func bindProgressData() {
        guard let student = students else { return }
        
        student.progress.data?.forEach({ data in
            self.date.append(data.time ?? 0)
            self.numbers.append(Double(data.score ?? 0))
        })
    }
    
    func dateConverted(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    @IBAction func handleAddProgressBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddStudentTarget_VC") as! AddStudentTargetViewController
        vc.students = students
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            lineChartEntry.append(ChartDataEntry(x: Double(i), y: numbers[i]))
        }
        
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntry, label: "Date") //Here we convert lineChartEntry to a LineChartDataSet
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
        lineChartDataSet.colors = [NSUIColor.blue] //Sets the colour to blue
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        var dateString: [String] = []
        date.forEach { timestamp in
            let convertedDate = timestampToDateString(timestamp: Double(timestamp))
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
    
    private func timestampToDateString(timestamp: Double) -> String {
        let unixTimeStamp: Double = Double(timestamp) / 1000.0
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "dd/MM/yyy"
        return formatter.string(from: date)
    }
}

extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberObjects = self.numbers.count + 1
        if numberObjects == 1 {
            tableView.setEmptyView(title: "No data recorded", message: "Add some progress by pressing button below", withButton: true)
            numberObjects = 0
        } else {
            tableView.restore()
        }
        return numberObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "targetCellId", for: indexPath)
        
        if indexPath.row == self.numbers.count {
            cell.textLabel?.text = "+ Add New Progress"
            cell.textLabel?.textColor = .primaryColor
            cell.detailTextLabel?.text = ""
        } else {
            
            let dateLabel = timestampToDateString(timestamp: Double(self.date[indexPath.row]))
            let progressLabel = self.numbers[indexPath.row]
            
            cell.textLabel?.text = "\(dateLabel)"
            cell.detailTextLabel?.text = "\(progressLabel)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == self.numbers.count {
            print("Hello world")
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStudentProgress_VC") as! AddStudentProgressViewController
            vc.student = students
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        print("Hello world")
    }
}
