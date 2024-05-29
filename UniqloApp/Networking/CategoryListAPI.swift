//
//  CategoryListAPI.swift
//  UniqloApp
//
//  Created by ThinhND3 on 29/05/2024.
//

import Foundation
import SwiftyJSON

class CategoryListAPI: APIOperation<CategoryListResponse> {
    init() {
        super.init(request: APIRequest(name: "API get list category",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "categories",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct CategoryListResponse: APIResponseProtocol {
    var data: [CategoryInfo] = []
    init(json: JSON) {
        data = json["data"].arrayValue.map({CategoryInfo(json: $0)})
    }
}

struct CategoryInfo: Codable {
    var id: Int?
    var name: String?
    var isActive: Bool?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        isActive = json["town_kana"].bool
    }
}
