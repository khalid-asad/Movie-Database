//
//  CreditsRequest.swift
//  TMDb
//
//  Created by Khalid Asad on 8/21/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import protocol PlatformCommon.Networkable

struct CreditsRequest: Networkable {
    
    var id: Int
    
    var apiKey: String? {
        StringKey.apiKey.rawValue
    }
    
    var baseURL: String {
        StringKey.baseURL.rawValue
    }
    
    var urlPath: String? {
        StringKeyFormatter.creditsURL(id: id).path
    }
}
