//
//  NetworkRequestType.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

/// The possible HTTP Request types.
public enum NetworkRequestType: String, Codable, Equatable, Hashable {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
