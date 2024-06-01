import Foundation
import Alamofire
import SwiftyJSON

struct CartResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [CartData]
}

struct CartData: Codable {
    let id: Int
    let variation_id: Int
    let quantity: Int
    let account_id: Int
}

class AddItemToCartAPI {
    func addItemToCartAPI(accountId: Int, variationId: Int, quantity: Int) {
        let apiURL = URL(string: "\(APIMainEnviroment().baseUrl)/carts/create")!

        let requestBody: [String: Any] = [
            "account_id": accountId,
            "variation_id": variationId,
            "quantity": quantity
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
                        let cartResponse = try JSONDecoder().decode(CartResponse.self, from: data)
                        print("Phản hồi từ API:")
                        print("Status code: \(cartResponse.statusCode)")
                        print("Message: \(cartResponse.message)")
                        print("Data: \(cartResponse.data)")
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
}

