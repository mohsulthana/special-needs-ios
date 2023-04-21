//
//  PickSubjectVC.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/25/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import UIKit

class PickSubjectVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var grade: Grades?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Notification Methods
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
    // MARK: - Memory Cleanup
    
}

// MARK: - UITableViewDataSource Methods

extension PickSubjectVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grade?.subjects?.array.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickSubjectCell.cellID, for: indexPath) as! PickSubjectCell
        
        guard let grade else { return cell }
        
        cell.lblTitle.text = grade.subjects?.array[indexPath.row].name?.rawValue
        
        return cell
    }
}

// MARK: - UITableViewDelegate Methods

extension PickSubjectVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoalsVC") as! GoalsVC
        
        guard let grade else { return }
        vc.documentID = grade.documentID
        vc.subjectName = grade.subjects?.array[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
}
