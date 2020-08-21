//
//  Dictionary+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/20/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

extension Dictionary where Key == String, Value == Any {
    
    /// Returns a decoded JSON from a String/Any Dictionary given a Value type to cast to.
    /// - parameter options: JSON Serialization Writing Options. i.e. [.prettyPrinted]
    /// - parameter dateDecodingStrategy: JSON Decoder Date Decoding Strategy. i.e. .iso8601
    func decodedJSON<T: Decodable>(options: JSONSerialization.WritingOptions = [], dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self, options: options)
        let decoder = JSONDecoder()
        if let dateDecodingStrategy = dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        }
        return try decoder.decode(T.self, from: data)
    }
}
