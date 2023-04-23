//
//  SelectGradeVC.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import MessageUI
import RealmSwift
import SwiftyJSON
import UIKit

class SelectGradeVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imgvBook: UIImageView!
    @IBOutlet var supportUsButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!

    var arrGrades = [Grades]() {
        didSet {
            self.tableView.reloadData()
        }
    }

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
            self.fetchGradeFirestore()
        }
    }

    // MARK: - Notification Methods

    // MARK: - Public Methods

    @IBAction func handleLoginButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginStoryboard") as? LoginViewController {
            let navigationVc = UINavigationController(rootViewController: vc)
            navigationVc.modalPresentationStyle = .fullScreen
            present(navigationVc, animated: true, completion: nil)
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchGradeFirestore()

        refreshControl.endRefreshing()
    }

    func addNewGrade() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddGradeVC") as? AddGradeViewController {
            let navigationVc = UINavigationController(rootViewController: vc)
            navigationVc.modalPresentationStyle = .fullScreen
            present(navigationVc, animated: true, completion: nil)
        }
    }

    // MARK: - API Methods

    private func fetchGradeFirestore() {
        GradeService.shared.fetchGrades { grades, error in
            if let error {
                self.view.makeToast(error.localizedDescription)

                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                return
            }

            guard let grades else { return }

            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }

            self.arrGrades = grades
        }
    }

    // MARK: - Action Methods

    private func getGradesAPI() {
        var request = URLRequest(url: URL(string: "https://rnd4tooktech2019.blob.core.windows.net/specialneedsapp/data/v1.0.json")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, _, _ in
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
        return arrGrades.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectYourGradeCell.cellID, for: indexPath) as! SelectYourGradeCell

        let type = arrGrades[indexPath.section]
        cell.lblGrade.text = type.grade

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == arrGrades.count {
            addNewGrade()
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PickSubjectVC") as! PickSubjectVC
            vc.grade = arrGrades[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
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
