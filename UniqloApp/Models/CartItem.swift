//
//  CartItem.swift
//  UniqloApp
//

import Foundation

struct CartItem: Codable {
    var item: UniqloItem
    var itemCount: Int
    
    init(item: UniqloItem, count: Int) {
        self.item = item
        self.itemCount = count
    }
    
    func getPriceString() -> String {
        let priceString = "\(self.item.price)".formattedNumberString(newString: "")
        return "\(priceString)$"
    }
    
    func getTotalPriceString() -> String {
        let total: Int = self.item.price * self.itemCount
        let totalPriceString = "\(total)".formattedNumberString(newString: "")
        return "\(totalPriceString)$"
    }
}

class CartManager: NSObject {
    
    @objc static let shared = CartManager()
    
    override init() {
    }
    private let cartDataKey = "cartData"
    var cartData: [CartItem] {
        set(value) {
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(value) else {
                return
            }
            UserDefaults.standard.set(data, forKey: cartDataKey)
        }
        get {
            let jsonDecoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: cartDataKey),
                  let recordData = try? jsonDecoder.decode([CartItem].self, from: data) else {
                return []
            }
            return recordData
        }
    }
    
    func addToCart(item: CartItem) {
        var updatedCartData = cartData
           var itemExists = false
           
           for (index, cartItem) in updatedCartData.enumerated() {
               if cartItem.item.id == item.item.id {
                   // If item already exists, increase the count
                   updatedCartData[index].itemCount += item.itemCount
                   itemExists = true
                   break
               }
           }
           
           if !itemExists {
               // If item does not exist, append it to the cartData array
               updatedCartData.append(item)
           }
           
           // Update cartData
           cartData = updatedCartData
    }
    
    func removeItem(withId id: Int) {
        var updatedCartData = cartData
        updatedCartData.removeAll { $0.item.id == id }
        
        // Update cartData
        cartData = updatedCartData
    }
    
    func updateItem(item: CartItem) {
        var updatedCartData = cartData
        for (index, cartItem) in updatedCartData.enumerated() {
            if cartItem.item.id == item.item.id {
                // Update the count of the item
                updatedCartData[index].itemCount = item.itemCount
                break
            }
        }
        
        // Update cartData
        cartData = updatedCartData
    }
    
    func getTotalPrice() -> String {
        var totalPrice = 0
        for item in cartData {
            totalPrice += item.item.price * item.itemCount
        }
        return "\(totalPrice)".formattedNumberString(newString: "") + "$"
    }
}
