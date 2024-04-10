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
    
    init(id: Int, name: String, des: String, price: Int) {
        self.id = id
        self.price = price
        self.des = des
        self.name = name
    }
}
