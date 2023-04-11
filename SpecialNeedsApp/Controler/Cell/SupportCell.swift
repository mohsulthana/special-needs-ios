//
//  SupportCell.swift
//  SpecialNeedsApp
//
//  Created by Valentin Bran on 18/03/2021.
//  Copyright © 2021 Gustavo Ortega. All rights reserved.
//

import UIKit

class SupportCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
       
    static var cellID = "SupportCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabel.layer.cornerRadius = 7.0
        priceLabel.layer.borderWidth = 2.0
        priceLabel.layer.borderColor = UIColor.white.cgColor
    }

}
