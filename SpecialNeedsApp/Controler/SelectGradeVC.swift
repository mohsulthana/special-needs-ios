//
//  SelectGradeVC.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import MessageUI

class SelectGradeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgvBook: UIImageView!
    @IBOutlet weak var supportUsButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let arrGrades = appDelegate.realm.objects(Grade.self)
        
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(SelectGradeVC.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .red
        
        return refreshControl
    }()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spinner.startAnimating()
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getGradesAPI()
        }
    }
    
    // MARK: - Notification Methods
    
    // MARK: - Public Methods
    @IBAction func handleLoginButton(_ sender: Any) {

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginStoryboard") as? LoginViewController {
            
            let navigationVc = UINavigationController(rootViewController: vc)
            navigationVc.modalPresentationStyle = .fullScreen
            self.present(navigationVc, animated: true, completion: nil)
        }
    }
    // MARK: - Custom Methods
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        imgvBook.layer.cornerRadius = 8.0
        supportUsButton.layer.cornerRadius = 8.0
        supportUsButton.layer.borderWidth = 2.0
        supportUsButton.layer.borderColor = UIColor.white.cgColor
        
        tableView.addSubview(refreshControl)
    }
    
    @IBAction func supportUsTaped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getGradesAPI()
        
        refreshControl.endRefreshing()
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
    
    func askForSendingEmail() {
        let alert = UIAlertController(title: "ADD A NEW GOAL?", message: "You have the option to submit a new goal. This will be sent to admin via email, and you will be notified via email about the status. \n\n Do you want to continue?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            self.openEmailSheet()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
    private func getGradesAPI() {
        var request = URLRequest(url: URL(string: "https://rnd4tooktech2019.blob.core.windows.net/specialneedsapp/data/v1.0.json")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
            guard let me = self else { return }
            do {
                let jsonData = try JSON(data: data!)
                
                Grade.saveGrades(jsonData["Grades"])
                
                DispatchQueue.main.async {
                    me.spinner.stopAnimating()
                    me.spinner.isHidden = true
                    me.tableView.isHidden = false
                    me.tableView.reloadData()
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    // MARK: - Memory Cleanup
    
}

// MARK: - UITableViewDelegate Methods

extension SelectGradeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrGrades.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectYourGradeCell.cellID, for: indexPath) as! SelectYourGradeCell
        
        if indexPath.section == arrGrades.count {
            cell.lblGrade.text = "+ Add New Goal"
        }
        else {
            let type = arrGrades[indexPath.section]
            cell.lblGrade.text = type.gradeName
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == arrGrades.count {
            askForSendingEmail()
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickSubjectVC") as! PickSubjectVC
            vc.grade = arrGrades[indexPath.section]
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
}

// MARK: - MFMailComposeViewControllerDelegate Methods

extension SelectGradeVC: MFMailComposeViewControllerDelegate {
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
