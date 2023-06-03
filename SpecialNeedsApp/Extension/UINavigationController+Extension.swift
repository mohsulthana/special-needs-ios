//
//  UINavigationController+Extension.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 03/06/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import UIKit

extension UINavigationController {
    func getViewController<T: UIViewController>(of type: T.Type) -> UIViewController? {
        return self.viewControllers.first(where: { $0 is T })
    }

    func popToViewController<T: UIViewController>(of type: T.Type, animated: Bool) {
        guard let viewController = self.getViewController(of: type) else { return }
        self.popToViewController(viewController, animated: animated)
    }
}
