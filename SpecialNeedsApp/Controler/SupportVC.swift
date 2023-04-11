//
//  SupportVC.swift
//  SpecialNeedsApp
//
//  Created by Valentin Bran on 18/03/2021.
//  Copyright © 2021 Gustavo Ortega. All rights reserved.
//

import UIKit
import StoreKit

class SupportVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [SKProduct]?
    let billingController = BillingController()
    
    // MARK: - View Lifecycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        billingController.onPurchased = { [weak self] identifier in
            if !identifier.isEmpty {
                self?.present(Utils.okAlertController("Great", message: "Thank you for your support."), animated: true)
            }
        }
        
        billingController.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            if let products = products, success {
                self.products = products.sorted { $0.price.doubleValue < $1.price.doubleValue }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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

extension SupportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SupportCell.cellID, for: indexPath) as! SupportCell
        
        if let product = products?[indexPath.row] {
            cell.descriptionLabel.text = product.localizedDescription
            cell.priceLabel.text = "$ \(product.price.stringValue)"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate Methods

extension SupportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let product = products?[indexPath.row] {
            billingController.buyProduct(product)
        }
    }
}
