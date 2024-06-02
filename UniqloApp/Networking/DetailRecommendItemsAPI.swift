//
//  DetailRecommendItemsAPI.swift
//  UniqloApp
//
//  Created by Nguyễn Thị Vân Anh on 02/06/2024.
//


//struct DetailRecommendItemsProduct {
//    let name: String
//    let productId: Int
//}
//
//struct DetailRecommendItemsResponse {
//    let data: [DetailRecommendItemsProduct]
//    let message: String
//    let statusCode: Int
//}

import Foundation
import SwiftyJSON

class DetailRecommendItemsProductAPI: APIOperation<DetailRecommendItemsProductResponse> {
    init() {
        let id = 4
        super.init(request: APIRequest(name: "API recommend",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "recommend/\(id)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct DetailRecommendItemsProductResponse: APIResponseProtocol {
    var data: [DetailRecommendItemsProduct] = []
    init(json: JSON) {
        data = json["data"].arrayValue.map({DetailRecommendItemsProduct(json: $0)})
    }
}

struct DetailRecommendItemsProduct: Codable {
    let name: String?
    let productId: Int?
    
    init(json: JSON) {
        name = json["name"].string
        productId = json["product_id"].int

    }
}


