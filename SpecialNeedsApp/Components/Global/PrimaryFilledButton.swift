//
//  Button.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryFilledButton: UIButton {
    
    // cannot be called cornerRadius since the Extension has a property with that name!
    @IBInspectable var borderRadius: CGFloat = 12 {
        didSet {
            layer.cornerRadius = borderRadius
            layer.masksToBounds = borderRadius > 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        customize()
    }
    
    func customize() {
        self.clipsToBounds = true
        layer.cornerRadius = borderRadius
        backgroundColor = UIColor.primaryColor
        tintColor = UIColor.primaryColor
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
    }
}
