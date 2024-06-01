//
//  SharedData.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 30/05/2024.
//

import Foundation

class SharedData {
    
    // Access token for requesting APIs
    class var accessToken: String? {
        get {
            return (UserDefaults.standard.value(forKey: "ApiAccessToken") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ApiAccessToken")
        }
    }
    
    class var userId: Int? {
        get {
            return (UserDefaults.standard.value(forKey: "userId") as? Int)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "userId")
        }
    }
    
    class var userName: String? {
        get {
            return (UserDefaults.standard.value(forKey: "userName") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "userName")
        }
    }
    
    class var email: String? {
        get {
            return (UserDefaults.standard.value(forKey: "email") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "email")
        }
    }

    class var password: String? {
        get {
            return (UserDefaults.standard.value(forKey: "password") as? String)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "password")
        }
    }
}
