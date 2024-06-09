//
//  CategoryCell.swift
//  UniqloApp
//
//  Created by AnhNTV3 on 02/04/2024.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var tagLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
