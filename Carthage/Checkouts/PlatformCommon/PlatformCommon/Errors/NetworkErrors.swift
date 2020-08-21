//
//  NetworkErrors.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

/// Various networking errors encountered.
public enum NetworkError: CustomError, Equatable {
    case emptyResponse
    case invalidAPIKey
    case invalidHTTPResponse
    case invalidJSONResponse
    case invalidURL
    case noData
    case noReference
    case notFound
    case other(String, Int)
    case unableToDecodeJSON
    case unauthorized
    case unknown
    
    /// The user friendly error message.
    public var message: String {
        switch self {
        case .emptyResponse:
            return "The response is nil or empty."
        case .invalidAPIKey:
            return "Invalid API key: You must be granted a valid key."
        case .invalidHTTPResponse:
            return "The HTTP URL Response was invalid."
        case .invalidJSONResponse:
            return "The JSON Response was invalid."
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "The request returned no data."
        case .noReference:
            return "There is no reference to the resource due to thread mismanagement"
        case .notFound:
            return "The resource you requested could not be found."
        case .other(let statusMessage, let statusCode):
            return "Status Code: \(statusCode), Status Message: \(statusMessage)"
        case .unableToDecodeJSON:
            return "Unable to decode the JSON response."
        case .unauthorized:
            return "This user is not authorized."
        case .unknown:
            return "An Unknown error occurred."
        }
    }
}
