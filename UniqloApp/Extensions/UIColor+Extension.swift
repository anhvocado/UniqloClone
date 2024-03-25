//
//  UIColor+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 5/7/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension UIColor {
    static var uncheckColor: UIColor  {
        return #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1)
    }
    static var checkColor: UIColor {
        return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    static var notifyBorder: UIColor {
        return #colorLiteral(red: 0.9764705882, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
        
    }
    static var notifyBackground: UIColor {
        return #colorLiteral(red: 1, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        
    }
    
}
