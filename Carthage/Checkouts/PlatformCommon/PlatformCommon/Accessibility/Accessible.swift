//
//  Accessible.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

/// An Accessibility ID Generation protocol.
/// Create a private enum and conform to this protocol to generate Accessibility Identifiers.
public protocol Accessible: RawRepresentable where RawValue == String {
    
    /// The generated Accessibility Identifier.
    var id: String { get }
    
    /// The type of UI View the Accessibility Identifier needs to be generated for.
    var type: UIView.Type { get }
}

public extension Accessible {
    
    var id: String {
        generateAccessibilityID(for: rawValue, of: type)
    }
    
    func generateAccessibilityID(for name: String, of type: UIView.Type) -> String {
        "\(String(describing: self))_\(name)_\(type)"
    }
}
