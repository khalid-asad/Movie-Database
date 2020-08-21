//
//  Data+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 7/5/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public extension Data {
    
    /// NSString gives us a nice sanitized debugDescription.
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return nil }
        return prettyPrintedString
    }
}
