//
//  PickSubjectCell.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/25/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import UIKit

class PickSubjectCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    static var cellID = "PickSubjectCellID"

    override func awakeFromNib() {
        super.awakeFromNib()
       
        contentView.layer.cornerRadius = 7.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = selected == true ? .blue : .white
        lblTitle.textColor = selected == true ? .white : .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
}
