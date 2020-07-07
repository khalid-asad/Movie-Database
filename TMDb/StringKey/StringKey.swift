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

enum SearchURLQueryParameters {
    case query(_ query: String)
    case page(_ page: Int)
    
    var path: String {
        switch self {
        case .query(let query):
            return "&query=\((query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
        case .page(let page):
            return "&page=\(String(page))"
        }
    }
}

enum StringKeyFormatter {
    case searchURL(query: String, page: Int = 1)
    case creditsURL(id: Int)
    case movieImageDetailsURL(id: Int)
    
    var rawValue: String {
        switch self {
        case .searchURL(let query, let page):
            return StringKey.baseURL.rawValue +
                "/search/movie?api_key=\(StringKey.apiKey.rawValue)" +
                SearchURLQueryParameters.query(query).path +
                SearchURLQueryParameters.page(page).path
        case .creditsURL(let id):
            return StringKey.baseURL.rawValue +
                "/movie/\(id)/credits?api_key=\(StringKey.apiKey.rawValue)"
        case .movieImageDetailsURL(let id):
            return StringKey.baseURL.rawValue +
                "/movie/\(id)/images?api_key=\(StringKey.apiKey.rawValue)"
        }
    }
}

enum LocalErrors: LocalizedError {
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Decoding JSON failed."
        }
    }
}
