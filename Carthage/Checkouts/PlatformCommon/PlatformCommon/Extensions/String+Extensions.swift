//
//  String+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 4/18/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public extension String {

    /// Converts a string to Date format of yyyy-MM-dd.
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}
