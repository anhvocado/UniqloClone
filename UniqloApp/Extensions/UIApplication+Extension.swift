//
//  UIApplication+Extension.swift
//  VideoApp
//
//  Created by HongDT on 11/3/21.
//  Copyright © 2021 IchNV-D1. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(
        controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController, ignoreAlert: Bool = false
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if ignoreAlert {
            if let alert = controller as? UIAlertController {
                if let navigationController = alert.presentingViewController as? UINavigationController {
                    return navigationController.viewControllers.last
                }
                return alert.presentingViewController
            }
        }
        return controller
    }
}
