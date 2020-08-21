//
//  UIView+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 2019-06-24.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Retrieves a .xib file's nib value.
    class func fromNib<T: UIView>() -> T {
        // swiftlint:disable force_unwrapping
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    /// Adds a sub-view on the view.
    /// - parameter view: The sub-view to be added.
    /// - parameter edgeInset: The edge insets to constrain the view by.
    func addConstraintSubview(_ view: UIView, edgeInset: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: edgeInset.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeInset.bottom),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInset.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: edgeInset.right)
        ])
    }
    
    /// Utility function to quickly create a UI View.
    /// - parameter view: The sub-view.
    /// - parameter edgeInsets: The edge insets to constrain the view by.
    /// - parameter backgroundColor: The UI Color to set the background to.
    /// Returns: a configured parent UI View.
    static func createView(withSubview view: UIView, edgeInsets: UIEdgeInsets = .zero, backgroundColor: UIColor = .white) -> UIView {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = backgroundColor
        newView.addConstraintSubview(view, edgeInset: edgeInsets)
        return newView
    }
    
    /// Adds a border to a view.
    /// - parameter color: The color of the border as a UI Color.
    /// - parameter width: The width of the border as a CG Float.
    func addBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Round the corners of the current view.
    /// - parameter radius: The CG Float corner radius.
    func setRoundedCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// Adds a shadow to the view.
    /// - parameter color: The color of the border as a UI Color.
    /// - parameter opacity: The transparency of the view as a Float. Default is 0.5.
    /// - parameter offSet: The off-set of the shadow as a CG Size.
    /// - parameter radius: The CG Float corner radius. Default is 1.
    /// - parameter scale: Rasterization scale of the main screen scale if this is set to true, otherwise 1.
    func addShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
