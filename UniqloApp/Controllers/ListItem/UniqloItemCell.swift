//
//  UniqloItemCell.swift
//  UniqloApp
//

import UIKit
import SDWebImage

class UniqloItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    var item: UniqloProduct?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }

    func setupData(item: UniqloProduct) {
        self.item = item
        if let url = URL(string: self.item?.defImg ?? "") {
            self.itemImage.sd_setImage(with: url)
        }
        self.itemName.text = self.item?.name
        self.itemPrice.text = self.item?.getPriceString()
    }
}
