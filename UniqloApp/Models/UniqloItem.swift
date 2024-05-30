//
//  UniqloItem.swift
//  UniqloApp
//

import Foundation
import SwiftyJSON

struct UniqloItem: Codable {
    var id: Int
    var name: String
    var des: String
    var price: Int
    var imageName: String = ""
    
    init(id: Int, name: String, des: String, price: Int, imageName: String) {
        self.id = id
        self.price = price
        self.des = des
        self.name = name
        self.imageName = imageName
    }
    
    func getPriceString() -> String {
        let priceString = "\(self.price)".formattedNumberString(newString: "")
        return "\(priceString)$"
    }
}

struct AlterImage: Codable {
    var id: Int?
    var path: String?
    
    init(json: JSON) {
        id = json["id"].int
        path = json["image_path"].string
    }
}

struct Variation: Codable {
    var id: Int?
    var color: String?
    var price: String?
    var stock: Int?
    var sold: Int?
    var image: String?
    
    init(json: JSON) {
        id = json["id"].int
        stock = json["stock"].int
        sold = json["sold"].int
        color = json["color"].string
        price = json["price"].string
        image = json["image"].string
    }
}

struct UniqloProduct: Codable {
    var id: Int?
    var name: String?
    var price: String?
    var des: String?
    var spec: String?
    var defImg: String?
    var rating: String?
    var numberOfRating: Int?
    var discount: Int?
    var active: Bool?
    var createdAt: String?
    var brand: Brand?
    var images: [AlterImage] = []
    var variations: [Variation] = []
    
    init(json: JSON) {
        id = json["id"].int
        numberOfRating = json["numberRating"].int
        discount = json["discountPercentage"].int
        name = json["name"].string
        price = json["price"].string
        des = json["description"].string
        spec = json["specifications"].string
        createdAt = json["createdAt"].string
        rating = json["averageRating"].string
        defImg = json["defaultImage"].string
        active = json["active"].bool
        brand = Brand(json: json["brand"])
        images = json["images"].arrayValue.map({AlterImage(json: $0)})
        variations = json["variations"].arrayValue.map({Variation(json: $0)})
    }
    
    func getPriceString() -> String {
        let priceString = "\(self.price ?? "")"
        return "\(priceString)$"
    }
}

