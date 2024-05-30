//
//  LoginVC.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 25/03/2024.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLogin(_ sender: Any) {
        let emailAddress = self.emailTF.text ?? ""
        let passWord = self.passwordTF.text ?? ""
        
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(userName, forKey: "emailAddress")
//        userDefaults.set(userName, forKey: "passWord")
        LoginAPI(email: emailAddress, password: passWord).execute(success: { response in
            //get carts
            self.view.endEditing(true)
            SharedData.accessToken = response.data?.accessToken
            SharedData.email = response.data?.email
            SharedData.password = response.data?.password
            
            let mainVC = MainVC()
            self.navigationController?.pushViewController(mainVC, animated: true)
        }, failure: { error in
            print("Register error: \(error)")
        })
    }
}
