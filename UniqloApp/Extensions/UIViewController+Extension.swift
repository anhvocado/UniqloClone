//
//  Extension.swift
//  VideoApp
//
//  Created by IchNV-D1 on 5/5/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import UIKit
import AVKit

protocol XibViewController {
    static var name: String { get }
    static func create() -> Self
}

extension XibViewController where Self: UIViewController {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create() -> Self {
        return self.init(nibName: Self.name, bundle: nil)
    }
    
    static func present(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        parentVC.view.endEditing(true)
        let targetVC = create()
        prepare?(targetVC)
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
    
    static func presentWithNavigationController(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        parentVC.view.endEditing(true)
        let targetVC = create()
        prepare?(targetVC)
        let nav = UINavigationController(rootViewController: targetVC)
        parentVC.present(nav, animated: animated, completion: completion)
    }
    
    static func push(from: UIViewController? = top(),
                     animated: Bool = true,
                     prepare: ((_ vc: Self) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        parentVC.view.endEditing(true)
        let targetVC = create()
        prepare?(targetVC)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        parentVC.navigationController?.pushViewController(targetVC, animated: animated)
        CATransaction.commit()
    }
}

extension UIViewController: XibViewController { }

extension UIViewController {
    
    var name: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    var isModal: Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }

    class func top(controller: UIViewController? = AppDelegate.shared.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        if let tabController = controller as? UITabBarController {
            if tabController.moreNavigationController.viewControllers.count > 1 {
                return top(controller: tabController.moreNavigationController.visibleViewController)
            } else if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        return controller
    }
    
    class func getRootVC() -> UIViewController? {
        let controller = AppDelegate.shared.window?.rootViewController
        if let vc = controller as? UINavigationController {
            return vc.viewControllers.first
        }
        return controller
    }
    
    func dismissToRoot(controller: UIViewController? = UIViewController.top(),
                       animated: Bool = true,
                       completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        guard let getController = controller else {
            completion?(nil)
            return
        }
        if let prevVC = getController.presentingViewController {
            if prevVC.isModal && prevVC.presentingViewController != nil {
                dismissToRoot(controller: prevVC, animated: animated, completion: completion)
            } else {
                getController.dismiss(animated: animated, completion: {
                    completion?(prevVC)
                })
            }
        } else {
            completion?(getController)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    static func pop(controller: UIViewController? = top(), animated: Bool = true) {
        controller?.navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func push(to viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func removeController(asChildViewController viewController: UIViewController) {
        if viewController.isViewLoaded {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    func addController(viewController: UIViewController, toView: UIView, completion: (() -> Void)? = nil) {
        self.addChild(viewController)
        toView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        viewController.view.frame = toView.bounds;
        if let completion = completion {
            completion()
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-75, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2 + self.view.frame.size.height/3)
        self.view.addSubview(toastLabel)
        
        
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
