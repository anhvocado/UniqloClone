//
//  UniqloItem.swift
//  UniqloApp
//

import Foundation

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
