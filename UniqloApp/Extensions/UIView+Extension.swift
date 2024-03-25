//
//  UIView+Extension.swift
//  VideoApp
//
//  Created by QuyNM on 5/6/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import Foundation
import UIKit

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
}

extension UIView: XibView { }

extension UIView {
    static func addCoverView(to view: UIView) -> UIView {
        let coverView = UIView()
        coverView.backgroundColor = .black
        coverView.alpha = 0.5
        view.addSubview(coverView)
        coverView.frame = view.bounds
        view.bringSubviewToFront(coverView)
        return coverView
    }
    
    static func removeCoverView(coverView: UIView, from view: UIView) {
        if coverView.isDescendant(of: view) {
            view.sendSubviewToBack(coverView)
        }
        coverView.removeFromSuperview()
    }
}

extension UIView {
    var isViewEnabled: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set(value) {
            self.isUserInteractionEnabled = value
            self.alpha = value ? 1 : 0.4
        }
    }
    
    var name: String {
        return type(of: self).name
    }
    
    class func nib() -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed( name, owner: nil, options: nil)![0] as! T
    }
    
    func fitParent(padding: UIEdgeInsets = .zero) {
        
        guard let parent = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: padding.top),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: padding.left),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: padding.bottom),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: padding.right)
        ])
    }
    
    class func viewFromNibName(_ name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views?.first as? UIView
    }
}


extension UIView {
    func setBorder(width: CGFloat, color: UIColor, radius: CGFloat = 0) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    func setBackgroundColor(color: UIColor) {
        self.layer.backgroundColor = color.cgColor
    }
    
    func constraintToAllSides(of container: UIView, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: topOffset),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leftOffset),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: rightOffset),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomOffset)
        ])
    }
}

extension UIView {
    //Hide a view with default animation
    func hide(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        //allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || self.isHidden {
                self.isHidden = true
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { (success) in
                self.isHidden = true
                self.alpha = currentAlpha
                completion?()
            })
        }
    }
    
    //Show a view with animation
    func show(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        
        //allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || !self.isHidden {
                self.isHidden = false
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            self.alpha = 0.05
            self.isHidden = false
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = currentAlpha
            }, completion: { (success) in
                completion?()
            })
        }
    }
    
    //rotate view 3D with Z
    func rotate(duration: CFTimeInterval = 0.8, toValue: Any = Float.pi*2, repeatCount: Float = Float.infinity, removeOnCompleted: Bool = false) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.toValue = toValue
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removeOnCompleted
        layer.add(animation, forKey: "rotate")
    }
    
    // Remove rotate animation
    func stopRotate() {
        layer.removeAnimation(forKey: "rotate")
    }
    
    static let maxPriority: UILayoutPriority = UILayoutPriority(999)
    static let minPriority: UILayoutPriority = UILayoutPriority(1)
}

extension UIView {
    
    @IBInspectable var mborderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var mborderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var halfRadius: Bool {
        get {
            setNeedsDisplay()
            return layer.cornerRadius == frame.size.height/2
        }
        
        set {
            if newValue {
                clipsToBounds = true
                layer.cornerRadius = frame.size.height/2
                setNeedsDisplay()
            } else {
                layer.cornerRadius = cornorRadius
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var cornorRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            if halfRadius {
                return
            } else {
                layer.cornerRadius = newValue
                setNeedsDisplay()
            }
        }
    }
    
    func dashBorder(color: UIColor, dashLength: CGFloat = 0, betweenDashesSpace: CGFloat = 0) {
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = mborderWidth
        dashBorder.strokeColor = color.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.fillColor =  UIColor.clear.cgColor
        if cornorRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornorRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        
        layer.addSublayer(dashBorder)
    }
}

extension UIView {
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
}

extension UIView {
    func getSubviewsOfView(view: UIView) -> [UIView] {
        var subviewArray = [UIView]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview)
            subviewArray.append(subview)
        }
        return subviewArray
    }
    
    func setIdentifierForHiddenViews() {
        for view in getSubviewsOfView(view: self) {
            if let identifier = view.accessibilityIdentifier, view.isHidden {
                view.accessibilityIdentifier = "\(identifier)_hidden"
            }
        }
    }
}

extension UIView {
    enum BorderSide {
        case top
        case bottom
        case left
        case right
    }
    
    func addBorderToSide(_ side: BorderSide, color: UIColor?, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        
        switch side {
        case .top:
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .bottom:
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        case .right:
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        }
        
        addSubview(border)
    }
}

public extension UIView {
    
    func pinToSuperviewEdges(padding: CGFloat = 0.0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
        ])
    }
}
