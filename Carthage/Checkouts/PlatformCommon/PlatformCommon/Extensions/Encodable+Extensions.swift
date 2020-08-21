//
//  Encodable+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/21/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public extension Encodable {
    
    /// Encodes an Encodable object into a [String: Any] dictionary.
    func dictionary(options: JSONSerialization.ReadingOptions = [], dateEncodingStrategy: JSONEncoder.DateEncodingStrategy? = nil) throws -> [String: Any] {
        let encoder = JSONEncoder()
        if let dateEncodingStrategy = dateEncodingStrategy {
            encoder.dateEncodingStrategy = dateEncodingStrategy
        }
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: options) as? [String: Any] else {
            throw JSONError.unableToSerializeObject
        }
        return dictionary
    }
}
