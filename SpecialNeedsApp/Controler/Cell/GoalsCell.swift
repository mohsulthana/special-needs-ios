//
//  GoalsCell.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import UIKit

class GoalsCell: UITableViewCell {
    
    @IBOutlet weak var lblGoalsSubtitle: UILabel!
    @IBOutlet weak var lblGoals: UILabel!
       
    static var cellID = "GoalsCellID"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
