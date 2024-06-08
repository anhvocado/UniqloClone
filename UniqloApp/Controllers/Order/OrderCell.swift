//
//  OrderCell.swift
//  UniqloApp
//
//  Created by Vanh's Mac on 02/06/2024.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemsTotalPrice: UILabel!
    @IBOutlet weak var itemColorView: UIView!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var totalQuantity: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    var order: OrderItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        order = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(order: OrderItem) {
        self.order = order
        if let item = self.order {
            self.orderStatus.text = order.status
            self.itemName.text = order.details.first?.variation?.name
            self.itemPrice.text = "\(order.details.first?.variation?.price ?? "")$"
            self.itemQuantity.text = "x\(order.details.first?.quantity ?? 0)"
            self.itemColorView.backgroundColor = StringColor(rawValue: order.details.first?.variation?.color ?? "White")?.uiColor
            if let url = URL(string: order.details.first?.variation?.image ?? "") {
                self.itemImageView.sd_setImage(with: url)
            }
            self.itemsTotalPrice.text = "\(order.total ?? "")$"
            if order.getTotalQuantity() > 1 {
                self.totalQuantity.text = "\(order.getTotalQuantity()) item"
            } else {
                self.totalQuantity.text = "\(order.getTotalQuantity()) items"
            }
        }
    }
    
}
