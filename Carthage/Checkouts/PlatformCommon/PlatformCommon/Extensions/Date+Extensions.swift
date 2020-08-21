//
//  Date+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 4/18/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public extension Date {
    
    /// Converts a Date of format yyyy-MM-dd into a String of year.
    var toStringYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Converts a Date of format yyyy-MM-dd into a String of day/month/year format.
    var toStringSlashedDMY: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
