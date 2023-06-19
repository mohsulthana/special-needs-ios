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
    @IBOutlet weak var addProgressButton: UIButton!
    @IBOutlet weak var studentInfoContainerView: UIView!
    @IBOutlet weak var timingContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var students: StudentsModel?
    var progress: ProgressModel?

    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentSubjectLabel: UILabel!
    @IBOutlet weak var studentGoalLabel: UILabel!
    @IBOutlet weak var studentGradeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endedView: UIView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .red

        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchStudentProgress()

        refreshControl.endRefreshing()
    }
    
    var numbers: [Double] = []
    var date: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let student = students else { return }
        navigationItem.title = student.name
        studentNameLabel.text = student.name
        intervalLabel.text = student.progress.interval?.capitalized
        studentGoalLabel.text = student.progress.goal
        studentGradeLabel.text = student.progress.grade
        studentSubjectLabel.text = student.progress.subject
        endDateLabel.text = "End Date \(DateUtils.timestampToDateString(timestamp: Double(student.progress.endDate ?? 0)))"
        
        progressTableView.delegate = self
        progressTableView.dataSource = self
        
        view.frame = CGRect(x: 0, y: 0, width: rootView.frame.width, height: 1000)
        endedView.layer.cornerRadius = 4
        endedView.layer.masksToBounds = true
        endedView.isHidden = isTargetEnded()
        addProgressButton.isEnabled = isTargetEnded()
        
        setupUI()
    }
    
    private func setupUI() {
        studentInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        timingContainerView.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            studentInfoContainerView.bottomAnchor.constraint(equalTo: studentGoalLabel.bottomAnchor, constant: 16),
            timingContainerView.bottomAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 8),
            scrollView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    private func isTargetEnded() -> Bool {
        return students?.progress.endDate ?? 0 > Int(Date().timeIntervalSince1970)
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
            let convertedDate = DateUtils.timestampToDateString(short: true, timestamp: Double(timestamp))
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

        studentChart.chartDescription.text = "\(students?.name ?? "") progress"
    }
    
    @IBAction func handleAddProgressBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddStudentProgress_VC") as! AddStudentProgressViewController
        vc.student = students
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberObjects = numbers.count
        if numberObjects == 0 {
            tableView.setEmptyView(title: "No data recorded", message: "Add some progress to show the data on this page")
            numberObjects = 0
        } else {
            tableView.restore()
        }
        return numberObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "targetCellId", for: indexPath)
        
        let dateLabel = DateUtils.timestampToDateString(timestamp: Double(date[indexPath.row]))
        let progressLabel = numbers[indexPath.row]

        cell.textLabel?.text = "\(dateLabel)"
        cell.detailTextLabel?.text = "\(progressLabel)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hello world")
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        print("Hello world")
    }
}
