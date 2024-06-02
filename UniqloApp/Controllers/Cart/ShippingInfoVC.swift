//
//  ShippingInfoVC.swift
//  UniqloApp
//
//  Created by Nguyễn Thị Vân Anh on 01/06/2024.
//

import UIKit

class ShippingInfoVC: BaseVC {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    var totalPrice: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GetCartItemAPI(id: SharedData.userId ?? 0).execute(success: {[weak self] response in
            for item in response.data {
                if let price = item.variation?.price, let quantity = item.quantity {
                    let totalItemPrice = (Double(price) ?? 0) * Double(quantity)
                    self?.totalPrice += totalItemPrice
                }
            }
        }, failure: { error in
            print(error)
        })
    }
    
    func createOrder(accountId: Int, name: String, address: String, phone: String, total: Double, pay: Bool) {
        let apiURL = URL(string: "\(APIMainEnviroment().baseUrl)/orders/create")!
            let requestBody: [String: Any] = [
                "account_id": accountId,
                "name": name,
                "address": address,
                "phone": phone,
                "total": total,
                "pay": pay
                ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])

            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Lỗi khi gọi API: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let cartResponse = try JSONDecoder().decode(OrderResponse.self, from: data)
                        print("Phản hồi từ API:")
                        print("Status code: \(cartResponse.statusCode)")
                        print("Message: \(cartResponse.message)")
                        print("Data: \(cartResponse.data)")
                        DispatchQueue.main.async {
                            self.pop()
                        }
                    } catch {
                        print("Lỗi khi parse phản hồi từ API: \(error)")
                    }
                }
            }

            task.resume()
        } catch {
            print("Lỗi khi chuyển dữ liệu body thành JSON: \(error)")
        }
    }
    
    @IBAction func onSubmitOrder(_ sender: Any) {
        self.createOrder(accountId: SharedData.userId ?? 0, name: nameTF.text ?? "", address: addressTF.text ?? "", phone: phoneTF.text ?? "", total: totalPrice, pay: true)
    }
}
