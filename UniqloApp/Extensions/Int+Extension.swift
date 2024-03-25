//
//  Int+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 6/15/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation

extension Int {
    func rewriteDateTime() -> String {
        if self < 10 {
            return "0\(self)"
        }
        return "\(self)"
    }
    
    func toDuration() -> String {
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        
        if self >= 3600 {
            hours = self / 3600
            minutes = (self - (hours * 3600)) / 60
            if minutes > 0 {
                seconds = (self - (hours * 3600)) - (minutes * 60)
            } else {
                seconds = self - (hours * 3600)
            }
        } else if self >= 60 {
            minutes = self / 60
            seconds = self - (minutes * 60)
        } else {
            seconds = self
        }
        
        if hours == 0 {
            return "\(minutes.rewriteDateTime()):\(seconds.rewriteDateTime())"
        }
        
        return "\(hours.rewriteDateTime()):\(minutes.rewriteDateTime()):\(seconds.rewriteDateTime())"
    }
}


