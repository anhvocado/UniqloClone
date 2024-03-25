//
//  UIImage+Extension.swift
//  VideoApp
//
//  Created by IchNV on 5/28/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//


import UIKit

extension UIImage {
    // MARK: - Variables
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func renderOriginal() -> UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    func renderTemplate() -> UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        return newImage
    }
}
