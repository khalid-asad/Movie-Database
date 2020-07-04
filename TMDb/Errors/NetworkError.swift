//
//  NetworkError.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

enum NetworkError: Error {
    case emptyResponse
    case noReference
    
    var localizedDescription: String {
        switch self {
        case .emptyResponse:
            return "The response is nil or empty."
        case .noReference:
            return "There is no reference to the resource due to thread mismanagement"
        }
    }
}
