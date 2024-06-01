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
    var variation: CartInfoVariation?

    init(json: JSON) {
        id = json["id"].int
        variationId = json["variationId"].int
        quantity = json["quantity"].int
        variation = CartInfoVariation(json: json["variation"])
    }
    
    func getPriceString() -> String {
        let priceString = "\(self.variation?.price ?? "")"
        return "\(priceString)$"
    }
}

struct CartInfoVariation: Codable {
    var id: Int?
    var color: String?
    var price: String?
    var stock: Int?
    var sold: Int?
    var image: String?
    var product: CartItemProduct?
    
    init(json: JSON) {
        id = json["id"].int
        stock = json["stock"].int
        sold = json["sold"].int
        color = json["color"].string
        price = json["price"].string
        image = json["image"].string
        product = CartItemProduct(json: json["product"])
    }
}

struct CartItemProduct: Codable {
    var id: Int?
    var name: String?
    var price: String?
    var description: String?
    var specifications: String?
    var defaultImage: String?
    var averageRating: String?
    var numberRating: Int?
    var discountPercentage: Int?
    var active: Bool?
    var createdAt: String?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        price = json["price"].string
        description = json["description"].string
        specifications = json["specifications"].string
        defaultImage = json["defaultImage"].string
        averageRating = json["averageRating"].string
        numberRating = json["numberRating"].int
        discountPercentage = json["discountPercentage"].int
        active = json["active"].bool
        createdAt = json["createdAt"].string
    }
}





