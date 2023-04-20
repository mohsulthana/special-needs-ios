//
//  CustomTextField.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
        if textContentType == .password {
            setupPasswordTextfield()
        }
    }

    private func setupPasswordTextfield() {
        self.isSecureTextEntry = true
        
        let button = UIButton(frame: CGRect(x: -10, y: 0, width: 14, height: 14))
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        button.tintColor = UIColor.primaryColor
        rightView = button
        rightViewMode = .always
        
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    private func setup() {
        let padding = UIView(frame: CGRect(x: 2, y: 2, width: 8, height: 16))
        self.leftView = padding
        self.leftViewMode = .always
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14.0)
        ])
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: [
            .foregroundColor: UIColor.darkText,
            .font: UIFont.boldSystemFont(ofSize: 14.0)
        ])
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
}
