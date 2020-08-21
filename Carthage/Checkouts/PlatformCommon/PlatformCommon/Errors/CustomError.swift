//
//  CustomError.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import Foundation

/// An error unique to an application.
public protocol CustomError: LocalizedError {
    
    /// The readable error message.
    var message: String { get }
}

public extension CustomError {
    
    var localizedDescription: String { message }
    var errorDescription: String? { message }
}
