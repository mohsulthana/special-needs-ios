//
//  UIColor.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 13/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

extension UIColor {
    static let primaryColor = UIColor(red: 18/255, green: 78/255, blue: 97/255, alpha: 1)
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
