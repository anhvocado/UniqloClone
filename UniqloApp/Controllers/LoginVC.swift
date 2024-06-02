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
//        let emailAddress = self.emailTF.text ?? ""
//        let passWord = self.passwordTF.text ?? ""
//
//        LoginAPI(email: emailAddress, password: passWord).execute(success: { response in
//            //get carts
//            self.view.endEditing(true)
//            SharedData.accessToken = response.data?.accessToken
//            SharedData.email = response.data?.email
//            SharedData.password = response.data?.password
//            SharedData.userId = response.data?.id
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.changeRoot(MainVC())
//        }, failure: { error in
//            print("Register error: \(error)")
//            
//        })
//        DetailRecommendItemsProductAPI().execute(success: { response in
//            print("vanh giỏi vãi")
//        }, failure: { error ind
//            print(error)
//        })
        let urlString = "http://anhvocado.local:3006/recommend/10"
//        let urlString = "\(APIMainEnviroment().baseUrlV2)/recommend/10"
        
            if let url = URL(string: urlString) {
                let session = URLSession.shared
                
                // Tạo task để gọi API
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Lỗi khi gọi API: \(error)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                    if let dataArr = json?["data"] as? [[String: Any]] {
                                        for item in dataArr {
                                            if let name = item["name"] as? String,
                                               let productId = item["product_id"] as? Int {
                                                print("Tên sản phẩm: \(name), ID sản phẩm: \(productId)")
                                                //Append vào list recommend item id
                                            }
                                        }
                                    }
                                } catch {
                                    print("Lỗi khi parse dữ liệu JSON: \(error)")
                                }
                            }
                        } else {
                            print("API trả về mã lỗi: \(httpResponse.statusCode)")
                        }
                    }
                }
                
                task.resume()
            } else {
                print("URL không hợp lệ")
            }
    }
}
