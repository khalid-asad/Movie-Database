//
//  StringKey.swift
//  TMDb
//
//  Created by Khalid Asad on 11/12/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation

enum StringKey: String {
    case imageBaseURL = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    case baseURL = "https://api.themoviedb.org/3"
    case apiKey = "2a61185ef6a27f400fd92820ad9e8537"
}

enum StringKeyFormatter {
    case searchURL(query: String)
    
    var rawValue: String {
        switch self {
        case .searchURL(let query):
            return StringKey.baseURL.rawValue + "/search/movie?api_key=" + StringKey.apiKey.rawValue + "&query=" + (query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
    }
}
