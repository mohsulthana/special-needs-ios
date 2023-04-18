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
    
    var grade: Grades!
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickSubjectCell.cellID, for: indexPath) as! PickSubjectCell
        
//        let type = grade.arrSubjects[indexPath.section]
//        cell.lblTitle.text = type.subjName
        
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
//        vc.subject = "Hello" ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
