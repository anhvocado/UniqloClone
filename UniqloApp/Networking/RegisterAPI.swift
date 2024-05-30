//
//  RegisterAPI.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 29/05/2024.
//
 
import UIKit
import Alamofire
import SwiftyJSON
 
class RegisterAPI: APIOperation<RegisterResponse> {
 
    init(name: String, email: String, password: String) {
        let parameters: Parameters = [
            "name": name,
            "email": email,
            "password": password
        ]
        super.init(request: APIRequest(name: "API Register",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "auth/register",
                                       method: .post,
                                       parameters: .body(parameters)))
    }
}
 
struct RegisterResponse: APIResponseProtocol {
    var data: [RegisterInfo] = []
    init(json: JSON) {
        data = json["data"].arrayValue.map({RegisterInfo(json: $0)})
    }
}
 
struct RegisterInfo: Codable {
    var id: Int?
    var name: String?
    var email: String?
    var password: String?
    var phone: String?
    var image_path: String?
    var gender: String?
    var role: String?
    var active: Bool?
    var passwordReset: String?
    var birthday: String?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        email = json["email"].string
        password = json["password"].string
        phone = json["phone"].string
        image_path = json["image_path"].string
        gender = json["gender"].string
        role = json["role"].string
        active = json["active"].bool
        passwordReset = json["password_reset"].string
        birthday = json["birthday"].string
    }
}
