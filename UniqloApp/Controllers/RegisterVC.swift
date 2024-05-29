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
    
    @IBAction func onRegister(_ sender: Any) {
        let userName = self.nameTF.text ?? ""
        let emailAddress = self.emailTF.text ?? ""
        let passWord = self.passwordTF.text ?? ""
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userName, forKey: "userName")
        userDefaults.set(userName, forKey: "emailAddress")
        userDefaults.set(userName, forKey: "passWord")
 
        RegisterAPI(name: userName, email: emailAddress, password: passWord).execute(success: { response in
            let loginVC = LoginVC()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }, failure: { error in
            print("Register error: \(error)")
        })
    }
}
