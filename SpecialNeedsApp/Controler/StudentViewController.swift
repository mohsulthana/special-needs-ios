//
//  StudentViewController.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {
    
    var students = [StudentsModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await self.fetchStudents()
        }
    }
    
    private func fetchStudents() async {
        await StudentService.shared.fetchAllStudents { students, error in
            if let error {
                self.view.makeToast(error)
                return
            }
            
            guard let allStudent = students else { return }
            
            self.students = allStudent
        }
    }
}

extension StudentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StudentDetail_VC") as! StudentDetailViewController
        vc.students = students[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StudentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        cell.textLabel?.text = students[indexPath.row].name
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberObjects = students.count
        if numberObjects == 0 {
            tableView.setEmptyView(title: "No goals added", message: "Tap plus icon to add new goal")
            numberObjects = 0
        } else {
            tableView.restore()
        }
        return numberObjects
    }
}
