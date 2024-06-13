//
//  ProductDetailAPI.swift
//  UniqloApp
//
//  Created by AnhNTV3's Mac on 30/05/2024.
//

import Foundation
import SwiftyJSON

class GetRatingOfProductAPI: APIOperation<RatingResponse> {
    init(id: Int) {
        super.init(request: APIRequest(name: "API get ratings",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "evaluations/stars/\(id)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct RatingResponse: APIResponseProtocol {
    var items: [RatingDetail] = []
    init(json: JSON) {
        items = json["data"].arrayValue.map({RatingDetail(json: $0)})
    }
}

struct RatingDetail: Codable {
    var id: Int?
    var star: Int?
    var account: LoginInfo?
    
    init(json: JSON) {
        id = json["id"].int
        star = json["star"].int
        account = LoginInfo(json: json["account"])
    }
}

class GetWishlist: APIOperation<WishlistResponse> {
    init(id: Int) {
        super.init(request: APIRequest(name: "API get wishlist",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "accounts/get-wishlists-by-account/\(id)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct WishlistResponse: APIResponseProtocol {
    var items: [WishlistItem] = []
    init(json: JSON) {
        items = json["data"].arrayValue.map({WishlistItem(json: $0)})
    }
}

struct WishlistItem: Codable {
    var id: Int?
    var accountId: Int?
    var productId: Int?
    
    init(json: JSON) {
        id = json["id"].int
        accountId = json["account_id"].int
        productId = json["product_id"].int
    }
}

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
