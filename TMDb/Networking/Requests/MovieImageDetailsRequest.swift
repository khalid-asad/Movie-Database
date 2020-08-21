//
//  MovieImageDetailsRequest.swift
//  TMDb
//
//  Created by Khalid Asad on 8/21/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import protocol PlatformCommon.Networkable

struct MovieImageDetailsRequest: Networkable {
    
    var id: Int
    
    var apiKey: String? {
        StringKey.apiKey.rawValue
    }
    
    var baseURL: String {
        StringKey.baseURL.rawValue
    }
    
    var urlPath: String? {
        StringKeyFormatter.movieImageDetailsURL(id: id).path
    }
}
