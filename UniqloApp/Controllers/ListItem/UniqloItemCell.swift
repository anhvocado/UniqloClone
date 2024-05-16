//
//  UniqloItemCell.swift
//  UniqloApp
//

import UIKit

class UniqloItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    var item: UniqloItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }

    func setupData(item: UniqloItem) {
        self.item = item
        self.itemImage.image = UIImage(named: self.item?.imageName ?? "")
        self.itemName.text = self.item?.name
        self.itemPrice.text = self.item?.getPriceString()
    }
}
