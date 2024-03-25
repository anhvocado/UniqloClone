//
//  UICollectionReusableView+Extension.swift
//  VideoApp
//
//  Created by IchNV on 11/4/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import UIKit

// MARK: - UICollectionReusableView (Header & Footer)

protocol XibCollectionSupplementary {
    static var name: String { get }
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind)
    static func reusableFor(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self?
}

extension XibCollectionSupplementary where Self: UICollectionReusableView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind) {
        collectionView.register(Self.self, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: name)
    }
    
    static func reusableFor(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: name, for: indexPath) as? Self
    }
}

extension UICollectionReusableView: XibCollectionSupplementary { }

