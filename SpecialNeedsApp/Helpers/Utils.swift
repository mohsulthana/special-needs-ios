//
//  Utils.swift
//  SpecialNeedsApp
//
//  Created by Boariu Andy on 2/26/20.
//  Copyright © 2020 Gustavo Ortega. All rights reserved.
//

import Foundation
import UIKit

open class Utils {
    
    class func okAlertController(_ title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        return alert
    }
}
