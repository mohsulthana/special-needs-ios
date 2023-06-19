//
//  StudentViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addStudentBtn: UIBarButtonItem!
    var isReloadData = true
    
    var students = [StudentsModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .primaryColor

        return refreshControl
    }()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.showsVerticalScrollIndicator = true
        
        addStudentBtn.action = #selector(openAddStudentVC)
        addStudentBtn.target = self
    }
    
    @objc func openAddStudentVC() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let modalController = storyboard.instantiateViewController(withIdentifier: "AddStudent_VC") as! AddStudentViewController
        
        modalController.isDismissed = { [weak self] in
            Task {
                await self?.fetchStudents()
            }
        }
        present(modalController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isReloadData {
            Task {
                await self.fetchStudents()
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        Task {
            await self.fetchStudents()
            refreshControl.endRefreshing()
        }
    }
    
    private func fetchStudents() async {
        loadingIndicator.startAnimating()
        await StudentService.shared.fetchAllStudents { students, error in
            if let error {
                self.loadingIndicator.stopAnimating()
                self.view.makeToast(error)
                return
            }
            
            guard let allStudent = students else { return }
            
            self.students = allStudent.sorted(by: { $0.name > $1.name })
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}

extension StudentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if students[indexPath.row].progress.goal == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EmptyStudentDetail_VC") as! EmptyStudentDetailViewController
            vc.students = students[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else if students[indexPath.row].progress.data?.count == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EmptyProgress_VC") as! EmptyProgressViewController
            vc.student = students[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "StudentDetail_VC") as! StudentDetailViewController
            vc.students = students[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension StudentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        cell.textLabel?.text = students[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberObjects = students.count
        if numberObjects == 0 {
            tableView.setEmptyView(title: "No student to show", message: "Tap + to add new student")
            numberObjects = 0
        } else {
            tableView.restore()
        }
        return numberObjects
    }
}
