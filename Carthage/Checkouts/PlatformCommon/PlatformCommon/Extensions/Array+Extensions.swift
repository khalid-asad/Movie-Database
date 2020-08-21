//
//  Array+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 4/9/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public extension Array {
    
    /// Returns the element if it is a valid index range.
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
