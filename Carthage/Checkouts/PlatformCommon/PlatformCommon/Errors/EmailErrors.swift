//
//  EmailErrors.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public enum EmailErrors: CustomError, Equatable {
    case unableToOpenScheme(for: EmailApplication)
    case unableToParseURL
    case unableToSendEmail
    
    public var message: String {
        switch self {
        case .unableToOpenScheme(let application):
            return "Unable to Open the scheme for \(application.title)."
        case .unableToParseURL:
            return "Unable to parse the E-mail URL."
        case .unableToSendEmail:
            return "Unable to send the E-mail to it's destination."
        }
    }
}
