//
//  StatusResponse.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

struct StatusResponse: Codable {
    var statusCode: Int
    var statusMessage: String
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
}

extension StatusResponse {
    
    /// Returns the Error object associated with the error status code.
    var error: Error {
        switch statusCode{
        case 7:
            return NetworkError.invalidAPIKey
        case 34:
            return NetworkError.notFound
        default:
            return NetworkError.other(statusMessage, statusCode)
        }
    }
}
