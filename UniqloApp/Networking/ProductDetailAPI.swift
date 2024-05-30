//
//  ProductDetailAPI.swift
//  UniqloApp
//
//  Created by ThinhND3's Mac on 30/05/2024.
//

import Foundation
import SwiftyJSON

class ProductDetailAPI: APIOperation<ProductDetailResponse> {
    init(id: Int) {
        super.init(request: APIRequest(name: "API get product detail",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "products/\(id)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct ProductDetailResponse: APIResponseProtocol {
    var product: UniqloProduct?
    init(json: JSON) {
        product = UniqloProduct(json: json["data"])
    }
}

class ProductListAPI: APIOperation<ProductListResponse> {
    init() {
        super.init(request: APIRequest(name: "API get product list",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "products",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct ProductListResponse: APIResponseProtocol {
    var products: [UniqloProduct] = []
    init(json: JSON) {
        products = json["data"].arrayValue.map({UniqloProduct(json: $0)})
    }
}
