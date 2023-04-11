//
//  SelectYourGradeCell.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/25/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import UIKit

class SelectYourGradeCell: UITableViewCell {
    
    @IBOutlet weak var lblGrade: UILabel!
    
    static var cellID = "SelectYourGradeCellID"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 7.0
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = selected == true ? .white : .clear
        lblGrade.textColor = selected == true ? .red : .white
    }

}
