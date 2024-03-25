//
//  Throttler.swift
//  VideoApp
//
//  Created by IchNV-D1 on 5/8/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation


extension TimeInterval {

    /**
     Checks if `since` has passed since `self`.
     
     - Parameter since: The duration of time that needs to have passed for this function to return `true`.
     - Returns: `true` if `since` has passed since now.
     */
    func hasPassed(since: TimeInterval) -> Bool {
        return Date().timeIntervalSinceReferenceDate - self > since
    }

}

class Throttler {
    
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
   
    func throttle(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) {
        
            guard self.currentWorkItem == nil else { return }
            self.currentWorkItem = DispatchWorkItem {
                action()
                self.lastFire = Date().timeIntervalSinceReferenceDate
                self.currentWorkItem = nil
            }
            delay.hasPassed(since: self.lastFire) ? queue.async(execute: self.currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: self.currentWorkItem!)
    }
}

class Debouncer {
    
    var currentWorkItem: DispatchWorkItem?

    func debounce(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
        return {  [weak self] in
            guard let self = self else { return }
            self.currentWorkItem?.cancel()
            self.currentWorkItem = DispatchWorkItem { action() }
            queue.asyncAfter(deadline: .now() + delay, execute: self.currentWorkItem!)
        }
    }
}
