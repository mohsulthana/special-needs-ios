//
//  GoalsVC.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import UIKit
import MessageUI

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var subject: Subject!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Notification Methods
    
    // MARK: - Public Methods
    
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
        }
        else {
            let alert = Utils.okAlertController("Oops", message: "Your device has not Mail app available!")
            present(alert, animated: true)
        }
    }
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
    @IBAction func btnAddGoalAction() {
        let alert = UIAlertController(title: "ADD A NEW GOAL?", message: "You have the option to submit a new goal. This will be sent to admin via email, and you will be notified via email about the status. \n\n Do you want to continue?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            self.openEmailSheet()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Memory Cleanup
    
}

// MARK: - UITableViewDataSource Methods

extension GoalsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.arrGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalsCell.cellID, for: indexPath) as! GoalsCell
        
        let type = subject.arrGoals[indexPath.row]
        cell.lblGoals.text = type.goalName
        
        return cell
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
