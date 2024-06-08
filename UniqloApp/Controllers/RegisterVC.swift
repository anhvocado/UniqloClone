//
//  RegisterVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 25/03/2024.
//
 
import UIKit
 
class RegisterVC: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPressLogin(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.changeRoot(LoginVC())
    }
    
    
    @IBAction func onRegister(_ sender: Any) {
        let userName = self.nameTF.text ?? ""
        let emailAddress = self.emailTF.text ?? ""
        let passWord = self.passwordTF.text ?? ""
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userName, forKey: "userName")
        userDefaults.set(userName, forKey: "email")
        userDefaults.set(userName, forKey: "password")
 
        RegisterAPI(name: userName, email: emailAddress, password: passWord).execute(success: { response in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRoot(MainVC())
        }, failure: { error in
            print("Register error: \(error)")
        })
    }
}
