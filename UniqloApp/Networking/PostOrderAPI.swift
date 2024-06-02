//
//  PostOrderAPI.swift
//  UniqloApp
//
//  Created by Nguyễn Thị Vân Anh on 01/06/2024.
//

import Foundation
import SwiftyJSON

struct OrderResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [Order]
}

struct Order: Codable {
    let id: Int
    let name: String
    let phone: String
    let email: String?
    let address: String
    let note: String?
    let total: String
    let date: String
    let pay: Bool
    let status: String
    let account_id: Int
}

struct OrderListResponse: APIResponseProtocol {
    var data: [OrderItem]
    
    init(json: JSON) {
        data = json["data"].arrayValue.map({OrderItem(json: $0)})
    }
}

struct OrderDetail: Codable {
    var id: Int?
    var variation: VariationOrder?
    var quantity: Int?
    
    init(json: JSON) {
        variation = VariationOrder(json: json["variation"])
        id = json["id"].int
        quantity = json["quantity"].int
    }
}

struct VariationOrder: Codable {
    var name: String?
    var color: String?
    var price: String?
    var image: String?
    
    init(json: JSON) {
        name = json["name"].string
        color = json["color"].string
        price = json["price"].string
        image = json["image"].string
    }
}

struct OrderItem: Codable {
    var id: Int?
    var name: String?
    var phone: String?
    var email: String?
    var address: String?
    var note: String?
    var total: String?
    var date: String?
    var pay: Bool?
    var status: String?
    var details: [OrderDetail] = []
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        phone = json["phone"].string
        email = json["email"].string
        address = json["address"].string
        note = json["note"].string
        total = json["total"].string
        date = json["date"].string
        status = json["status"].string
        pay = json["pay"].bool
        details = json["details"].arrayValue.map({OrderDetail(json: $0)})
    }
    
    func getTotalQuantity() -> Int {
        var quantity: Int = 0
        details.forEach { item in
            quantity += item.quantity ?? 0
        }
        return quantity
    }
}

class OrderListAPI: APIOperation<OrderListResponse> {
    init() {
        super.init(request: APIRequest(name: "API get list order",
                                       baseURL: APIMainEnviroment().baseUrl,
                                       path: "orders/\(SharedData.userId ?? 0)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}
