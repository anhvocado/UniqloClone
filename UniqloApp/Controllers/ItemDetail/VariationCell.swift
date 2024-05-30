//
//  VariationCell.swift
//  UniqloApp
//
//  Created by Am dau's Mac on 30/05/2024.
//

import UIKit

enum StringColor: String {
    case pink = "Pink"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
    case black = "Black"
    case white = "White"
    case red = "Red"
    
    var uiColor: UIColor {
        switch self {
        case .pink:
            return UIColor.systemPink
        case .blue:
            return UIColor.systemBlue
        case .green:
            return UIColor.systemGreen
        case .yellow:
            return UIColor.systemYellow
        case .red:
            return UIColor.red
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        }
    }
}


class VariationCell: UICollectionViewCell {
    @IBOutlet weak var varCellColor: UIView!
    @IBOutlet weak var varCellBorder: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(item: Variation, isPicked: Bool = false) {
        if isPicked {
            varCellBorder.isHidden = false
        } else {
            varCellBorder.isHidden = true
        }
        varCellColor.backgroundColor = StringColor(rawValue: item.color ?? "White")?.uiColor
    }
}
