//
//  Bundle+Extension.swift
//  VideoApp
//
//  Created by IchNV-D1 on 5/27/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var bundleName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}
