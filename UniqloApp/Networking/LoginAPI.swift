//
//  LoginAPI.swift
//  UniqloApp
//
//  Created by Nguyễn Thị Vân Anh on 29/05/2024.
//

import Foundation
import SwiftyJSON
import Alamofire
 
class LoginAPI: APIOperation<LoginResponse> {
    init(email: String, password: String) {
        let parameters: Parameters = [
            "email": email,
            "password": password,
            "role": "user"
        ]
        super.init(request: APIRequest(name: "API login",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "/login",
                                       method: .post,
                                       parameters: .body(parameters)))
    }
}
 
struct LoginResponse: APIResponseProtocol {
    var data: LoginInfo?
    init(json: JSON) {
        data = LoginInfo(json: json["data"])
    }
}
 
struct LoginInfo: Codable {
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
//    var carts:
    var accessToken: String?
    var refreshToken: String?
    
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
//        carts =
        accessToken = json["accessToken"].string
        refreshToken = json["refreshToken"].string
    }
}
