//
//  PostOrderAPI.swift
//  UniqloApp
//
//  Created by Nguyễn Thị Vân Anh on 01/06/2024.
//

import Foundation
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


