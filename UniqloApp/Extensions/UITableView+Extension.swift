//
//  UITableView+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 5/5/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func registerNibHeaderFooterFor<T: UIView>(type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func scrollToBottom(list: [Any], animated: Bool = false) {
        if !list.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.scrollToRow(at: IndexPath(row: list.count - 1, section: 0), at: .bottom, animated: animated)
            })
        }
    }
    
    func scrollToTop() {
        if !self.visibleCells.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
        }
    }
    
    func reloadDataSmoothly() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        
        reloadData()
        beginUpdates()
        endUpdates()
        
        CATransaction.commit()
    }
}
