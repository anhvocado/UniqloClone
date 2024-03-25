//
//  UIImageView+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 5/11/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImageFromUrl(ImageURL :String, beforeSetImage: (( _ image: UIImage?) -> Void)? = nil) {
        if let imageFromCache = imageCache.object(forKey: ImageURL as NSString) {
            beforeSetImage?(imageFromCache)
            self.image = imageFromCache
            return
        }
        guard let url = URL(string: ImageURL) else { return }
        URLSession.shared.dataTask( with: url, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    let imageCached = UIImage(data: data)
                    imageCache.setObject(imageCached ?? UIImage(), forKey: ImageURL as NSString)
                    beforeSetImage?(imageCached)
                    self.image = imageCached
                }
            }
        }).resume()
    }
    
    func loadImage(url: URL?, placeholder: UIImage? = nil, showIndicatorView: Bool = false, forceToRefresh: Bool = false, completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        if showIndicatorView {
            self.kf.indicator?.startAnimatingView()
        }
        var options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        if forceToRefresh {
            options.append(.forceRefresh)
        }
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options, completionHandler:
                {
                    [weak self] result in
                    if showIndicatorView {
                        self?.kf.indicator?.stopAnimatingView()
                    }
                    switch result {
                    case .success(let value):
                        completion?(value.image, nil, value.source.url)
                    case .failure(let error):
                        completion?(nil, error, nil)
                    }
                })
    }
    
    func set(color: UIColor) {
        image = image?.renderTemplate()
        tintColor = color
    }
    
    func renderOriginal() {
        image = image?.renderOriginal()
    }
    
    func renderTemplate() {
        image = image?.renderTemplate()
    }
    
    func rotating(angle: CGFloat? = nil) {
        if let angle = angle {
            self.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
