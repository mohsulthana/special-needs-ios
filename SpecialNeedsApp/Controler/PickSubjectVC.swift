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
        var appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .primaryColor
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
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
        
        cell.lblTitle.text = grade.sortedGrade[indexPath.row].name?.rawValue ?? ""
        cell.labelSubtitle.text = "\(grade.sortedGrade[indexPath.row].goals.count) goals"
        return cell
    }
}

// MARK: - UITableViewDelegate Methods

extension PickSubjectVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoalsVC") as! GoalsVC
        
        guard let grade else { return }
        
        vc.documentID = grade.documentID
        vc.subjectName = grade.sortedGrade[indexPath.row].name
        vc.grade = grade
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
