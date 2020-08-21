//
//  UIConfigureable.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 2019-06-24.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

/// Handles configurations of a UI Text based elements.
public protocol UITextConfigureable {
    
    /// Configures the UI Text.
    /// - parameter text: If this is nil, hide the element, otherwise set the text.
    func configure(text: String?)
}

extension UILabel: UITextConfigureable {
    
    public func configure(text: String?) {
        if let text = text {
            self.text = text
        } else {
            isHidden = true
        }
    }
}
