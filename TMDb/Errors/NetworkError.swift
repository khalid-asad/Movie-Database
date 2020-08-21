//
//  NetworkError.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import enum PlatformCommon.NetworkError

extension NetworkError {
    
    /// The status code of the TMDb API.
    var statusCode: Int? {
        switch self {
        case .invalidAPIKey: return 7
        case .notFound: return 34
        default: return nil
        }
    }
}
