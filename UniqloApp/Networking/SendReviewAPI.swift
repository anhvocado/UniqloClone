//
//  SendReviewAPI.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 02/06/2024.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ReviewResponse: Codable {
    let statusCode: Int
    let message: String
    let data: ReviewData
}

struct ReviewData: Codable {
    let star: Int
    let content: String
    let productId: Int
    let accountId: Int
}

class SendReviewAPI {
    func sendReview(accountId: Int, productId: Int, star: Int, content: String, completion: ((Error?) -> ())? = nil) {
        let apiURL = URL(string: "\(APIMainEnviroment().baseUrl)/evaluations/create")!

        let requestBody: [String: Any] = [
            "accountId": accountId,
            "productId": productId,
            "star": star,
            "content": content
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
                    completion?(error)
                    return
                }

                if let data = data {
                    do {
                        let cartResponse = try JSONDecoder().decode(ReviewResponse.self, from: data)
                        print("Phản hồi từ API:")
                        print("Status code: \(cartResponse.statusCode)")
                        print("Message: \(cartResponse.message)")
                        print("Data: \(cartResponse.data)")
                        completion?(nil)
                    } catch {
                        print("Lỗi khi parse phản hồi từ API: \(error)")
                        completion?(error)
                    }
                }
            }

            task.resume()
        } catch {
            print("Lỗi khi chuyển dữ liệu body thành JSON: \(error)")
            completion?(error)
        }

    }
}
