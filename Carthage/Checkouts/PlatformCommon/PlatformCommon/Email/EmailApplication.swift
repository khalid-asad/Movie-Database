//
//  EmailApplication.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public enum EmailApplication: String {
    case microsoftOutlook = "ms-outlook"
    
    public var title: String {
        switch self {
        case .microsoftOutlook:
            return "Microsoft Outlook"
        }
    }
    
    /// The URL Scheme .
    var urlScheme: URL {
        switch self {
        case .microsoftOutlook:
            // swiftlint:disable force_unwrapping
            return URL(string: "ms-outlook://compose?to=")!
        }
    }
}
