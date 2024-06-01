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
        self.emailTF.text = "user1@gmail.com"
        self.passwordTF.text = "user1@gmail.com"
    }

    @IBAction func onLogin(_ sender: Any) {
        let emailAddress = self.emailTF.text ?? ""
        let passWord = self.passwordTF.text ?? ""

        LoginAPI(email: emailAddress, password: passWord).execute(success: { response in
            //get carts
            self.view.endEditing(true)
            SharedData.accessToken = response.data?.accessToken
            SharedData.email = response.data?.email
            SharedData.password = response.data?.password
            SharedData.userId = response.data?.id
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.changeRoot(MainVC())
        }, failure: { error in
            print("Register error: \(error)")
            
        })
    }
}
