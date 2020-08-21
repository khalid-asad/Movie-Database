//
//  JSONError.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/21/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public enum JSONError: CustomError {
    case invalidJSON
    case unableToSerializeObject
    
    public var message: String {
        switch self {
        case .invalidJSON:
            return "Could not decode the JSON. Please try with a valid JSON."
        case .unableToSerializeObject:
            return "Could not serialize the object as a JSON."
        }
    }
}
