//
//  CGFloat+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 8/18/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var decimal: Decimal {
        return Decimal(string: "\(self)") ?? 0
    }
}
