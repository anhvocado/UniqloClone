//
//  GetCartItemAPI.swift
//  UniqloApp
//
//

import Foundation
import SwiftyJSON
import Alamofire

class GetCartItemAPI: APIOperation<GetCartItemResponse> {

    init(id: Int) {
        super.init(request: APIRequest(name: "API get cart items",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "carts/\(id)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct GetCartItemResponse: APIResponseProtocol {
    var data: [CartItemInfo] = []
    init(json: JSON) {
        data = json["data"].arrayValue.map({CartItemInfo(json: $0)})
    }
}

struct CartItemInfo: Codable {
    var id: Int?
    var variationId: Int?
    var quantity: Int?
    var variation: Variation?

    init(json: JSON) {
        id = json["id"].int
        variationId = json["variationId"].int
        quantity = json["quantity"].int
        variation = Variation(json: json["variation"])
    }
}

struct Variation: Codable {
    var id: Int?
    var color: String?
    var price: String?
    var stock: Int?
    var sold: Int?
    var image: String?
    //TODO
//    var product: ProductInfo?
    
    init(json: JSON) {
        id = json["id"].int
        color = json["color"].string
        price = json["price"].string
        stock = json["stock"].int
        sold = json["sold"].int
        image = json["image"].string
        //TODO
//        product = ProductInfo(json: json["product"])
    }
}
