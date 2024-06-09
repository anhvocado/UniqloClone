//
//  CheckOutItemCell.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 09/04/2024.
//

import UIKit

class CheckOutItemCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemPriceTotal: UILabel!
    @IBOutlet weak var quantityButton: UIButton!
    var didRemoveItem: ((Int) -> Void)?
    var didUpdateItem: ((CartItemInfo, UITableViewCell) -> Void)?
    var data: CartItemInfo?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.data = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(cartItem: CartItemInfo) {
        self.data = cartItem
        self.itemName.text = cartItem.variation?.product?.name
        if let url = URL(string: cartItem.variation?.image ?? "") {
            self.itemImage.sd_setImage(with: url)
        }
        self.itemCount.text = "\(cartItem.quantity ?? 0)"
        self.itemPrice.text = cartItem.getPriceString()
        if let price = cartItem.variation?.price, let quantity = cartItem.quantity {
            let totalPrice = (Double(price) ?? 0) * Double(quantity)
            self.itemPriceTotal.text = "\(totalPrice)0 $"
        }
    }
    
    
    
    func setupQuantityButton() {
        if #available(iOS 14.0, *) {
            quantityButton.showsMenuAsPrimaryAction = true
            quantityButton.menu = setupQuantityOptions()
        }
    }
    
    @available(iOS 14.0, *)
    private func setupQuantityOptions() -> UIMenu {
        let optionClosure = {(action: UIAction) in
            self.itemCount.text = action.title
            self.quantityButton.menu = self.setupQuantityOptions()
            self.data?.quantity = Int(action.title) ?? 1
            if let data = self.data {
                self.didUpdateItem?(data, self)
            }
            
        }
        var actions = [UIAction]()
        for item in self.generateStringArray(itemCount: data?.quantity ?? 0) {
            let state: UIAction.State = item == "\(data?.quantity ?? 0)" ? .on : .off
            let action = UIAction(title: item, state: state, handler: optionClosure)
            actions.append(action)
        }
        return UIMenu(children: actions)
    }
    
    func generateStringArray(itemCount: Int) -> [String] {
        let endValue = max(itemCount, 10)
        let stringArray = (1...endValue).map { String($0) }
        return stringArray
    }
    
    @IBAction func removeItem(_ sender: UIButton) {
        self.didRemoveItem?(data?.id ?? 0)
    }
}
