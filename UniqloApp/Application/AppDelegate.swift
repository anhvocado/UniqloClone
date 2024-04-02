//
//  AppDelegate.swift
//  UniqloApp
//
//  Created by ThinhND3 on 25/03/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = RegisterVC.create()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

