//
//  GoalsVC.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import MessageUI
import UIKit
import Toast

class GoalsVC: UIViewController {
    @IBOutlet var tableView: UITableView!

    @IBOutlet var spinner: UIActivityIndicatorView!
    var subject: Subject!
    var documentID: String?
    var subjectName: SubjectName?
    var grade: Grades?
    var goals = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = subjectName?.rawValue ?? ""
        tableView.isHidden = spinner.isAnimating ? true : false
        fetchGoals()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGoals()
    }

    // MARK: - Notification Methods

    // MARK: - Public Methods

    // MARK: - API Methods

    public func fetchGoals() {
        let id = documentID ?? ""
        let subject = subjectName ?? .other
        spinner.startAnimating()
        GoalService.shared.fetchGoals(student: subject, document: id) { goals, error in
            if let error {
                DispatchQueue.main.async {
                    self.view.makeToast(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                    }
                }
            }
            self.goals = goals ?? []
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
    }

    // MARK: - Custom Methods

    private func setupUI() {
    }

    func openEmailSheet() {
        let recipientEmail = "spedgoals2@gmail.com"
        let subject = "Add New Goal"
        let body = "Hey, I'd like to add a new goal!\n\n"

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = Utils.okAlertController("Oops", message: "Your device has not Mail app available!")
            present(alert, animated: true)
        }
    }

    // MARK: - API Methods

    // MARK: - Action Methods

    @IBAction func btnAddGoalAction() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddGradeVC") as? AddGradeViewController {
            vc.documentID = documentID
            vc.subjectName = subjectName ?? .other
            vc.goals = goals
            let navigationVc = UINavigationController(rootViewController: vc)
            navigationVc.modalPresentationStyle = .fullScreen
            present(navigationVc, animated: true, completion: nil)
        }
    }

    // MARK: - Memory Cleanup
}

// MARK: - UITableViewDataSource Methods

extension GoalsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberObjects = goals.count
        if numberObjects == 0 {
            tableView.setEmptyView(title: "No goals added", message: "Tap plus icon to add new goal")
            numberObjects = 0
        } else {
            tableView.restore()
        }
        return numberObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalsCell.cellID, for: indexPath) as! GoalsCell

        cell.lblGoals.text = goals[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let goal = goals[(indexPath as NSIndexPath).row]

        let trash = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] _, _, completionHandler in
            self?.handleMoveToTrash(goal: goal)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed

        let edit = UIContextualAction(style: .normal,
                                      title: "Edit") { [weak self] _, _, completionHandler in
            self?.handleEdit(selectedGoal: goal)
            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [trash, edit])

        return configuration
    }

    func handleMoveToTrash(goal: String) {
        let alert = UIAlertController(title: "Delet goal", message: "Are you sure to delete this goal?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.spinner.startAnimating()
            GoalService.shared.deleteGoal(goal: goal, key: self.subjectName ?? .other, documentID: self.documentID ?? "") { error in
                if let error {
                    DispatchQueue.main.async {
                        self.view.makeToast(error.localizedDescription)
                        self.spinner.stopAnimating()
                    }
                    return
                }
                self.view.makeToast("Successfully deleted goal")
                if let index = self.goals.firstIndex(of: goal) {
                    self.goals.remove(at: index)
                }
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    func handleEdit(selectedGoal: String) {
        let alert = UIAlertController(title: "Edit goal", message: "Set new goal for this subject", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter your new goal here"
            textField.clearButtonMode = .whileEditing
            textField.text = selectedGoal
            textField.addTarget(alert, action: #selector(alert.textValidateEmptyText), for: .editingChanged)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] _ in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            
            self.spinner.startAnimating()
            
            let arrayIndex = self.grade?.subjects?.array.firstIndex(where: { $0.name == self.subjectName }) ?? 0
            let index = self.grade?.subjects?.array[arrayIndex].goals.firstIndex(of: selectedGoal) ?? 0

            var newGoals: [String] = []

            newGoals = self.goals
            newGoals.append(userText)
            newGoals.remove(at: index)

            GoalService.shared.updateGoals(goal: newGoals, key: self.subjectName ?? .other, documentID: self.documentID ?? "", index: index) { error in
                if let error {
                    DispatchQueue.main.async {
                        self.view.makeToast(error.localizedDescription)
                        self.spinner.stopAnimating()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.goals = newGoals
                    self.view.makeToast("Successfully updated goal")
                    self.spinner.stopAnimating()
                }
            }
        }))

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate Methods

extension GoalsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

// MARK: - MFMailComposeViewControllerDelegate Methods

extension GoalsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            var status = ""
            switch result {
            case .cancelled:
                status = "Sending email canceled"

            case .saved:
                status = "Email saved"

            case .sent:
                status = "Email sent successfully!"

            case .failed:
                status = "Failed to send email. Please try again!"

            @unknown default:
                break
            }

            let alert = Utils.okAlertController(status, message: "")
            self.present(alert, animated: true)
        }
    }
}
