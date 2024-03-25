//
//  Array+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 6/3/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
