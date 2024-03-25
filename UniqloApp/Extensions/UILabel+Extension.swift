//
//  UILabel+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 5/11/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    var lineSpacing: CGFloat {
        get {
            return lineSpacingValue
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.lineSpacing = 7
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString
        }
    }
    
    private var lineSpacingValue: CGFloat {
        return lineSpacing
    }
    
    func checkTruncated() -> Bool {
        let textHeight = getTextHeightInlabel()
        var labelHeight: CGFloat = 0
        if self.numberOfLines == 0 {
            labelHeight = ceil(CGFloat(self.bounds.size.height))
        } else {
            labelHeight = ceil(CGFloat(self.font.lineHeight * CGFloat(self.numberOfLines)))
        }
        return textHeight > labelHeight
    }
    
    func getTextHeightInlabel() -> CGFloat {
        if let text = self.text {
            let myText = NSString(string: text)
            let attributes = [NSAttributedString.Key.font : self.font]
            let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            return ceil(CGFloat(labelSize.height))
        }
        return 0
    }
}
