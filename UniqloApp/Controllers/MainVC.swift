//
//  HomeVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 26/03/2024.
//

import UIKit

@objc protocol MainTabbarShowHideDelegate {
    func showMainTabbar()
    func hideMainTabbar()
    func showMainTabbarView()
    func hidenMainTabbarView()
}

class MainVC: UIViewController, UITabBarControllerDelegate, MainTabbarShowHideDelegate {
    func showMainTabbar() {
        <#code#>
    }
    
    func hideMainTabbar() {
        <#code#>
    }
    
    func showMainTabbarView() {
        <#code#>
    }
    
    func hidenMainTabbarView() {
        <#code#>
    }
    
    
    @IBOutlet weak var viewTabbar: UIView!
    public var tabbarViewController: UITabBarController!
    private var homeVC: HomeVC!
    public var cartVC: CartVC!
    public var profileVC: ProfileVC!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /*
     Create tabbar view controller
     */
    private func createTabbarView() {
        tabbarViewController = UITabBarController()
        tabbarViewController.delegate = self
        let tabbarTopConstraint = NSLayoutConstraint.init(item: tabbarViewController.view ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let tabbarLeftConstraint = NSLayoutConstraint.init(item: tabbarViewController.view ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let tabbarRightConstraint = NSLayoutConstraint.init(item: tabbarViewController.view ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let tabbarBottomConstraint = NSLayoutConstraint.init(item: tabbarViewController.view ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        tabbarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        tabbarViewController.view.backgroundColor = UIColor.clear
        tabbarViewController.viewControllers = createTabbarItem()
        tabbarViewController.tabBar.itemPositioning = .centered
        tabbarViewController.tabBar.itemSpacing = 6
        tabbarViewController.tabBar.itemWidth = 70
        tabbarViewController.selectedIndex = 0
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)

        self.addChild(tabbarViewController)
        self.view.insertSubview(tabbarViewController.view, belowSubview: viewTabbar)
        self.tabbarViewController.didMove(toParent: self)

        // Add constraint to parent view
        self.view.addConstraint(tabbarTopConstraint)
        self.view.addConstraint(tabbarLeftConstraint)
        self.view.addConstraint(tabbarRightConstraint)
        self.view.addConstraint(tabbarBottomConstraint)

        tabbarViewController.viewControllers?.forEach { _ = $0.view }

    }
    
    private func createTabbarItem() -> [UIViewController] {
        homeVC = HomeVC.create()
        cartVC = CartVC.create()
        profileVC = ProfileVC.create()
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeVC.navigationController?.setNavigationBarHidden(true, animated: false)
        homeVC.delegate = self
        homeVC.owner = self
        
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartVC.navigationController?.setNavigationBarHidden(true, animated: false)
        cartVC.delegate = self

        let profileNav = UINavigationController(rootViewController: profileVC)
        profileVC.navigationController?.setNavigationBarHidden(true, animated: false)
        profileVC.delegate = self

        return [homeNav, cartNav, profileNav]
    }
}
