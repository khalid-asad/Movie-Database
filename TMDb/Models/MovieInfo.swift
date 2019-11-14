//
//  MovieInfo.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

struct MovieInfo: Codable {
    var name: String
    var date: String
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
        case image
    }
}

struct MovieSearchQuery: Codable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [MovieSearchResult]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct MovieSearchResult: Codable {
    var popularity: Double
    var voteCount: Int
    var video: Bool
    var posterPath: String?
    var id: Int
    var adult: Bool
    var backdropPath: String?
    var originalLanguage: String
    var originalTitle: String
    var genreIDs: [Int]
    var title: String
    var voteAverage: Double
    var overview: String
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDs = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}

enum Genres: Int, CaseIterable {
    case all = 0
    case action = 28
    case comedy = 35
    case thriller = 53
    
    var name: String {
        switch self {
        case .all: return "All"
        case .action: return "Action"
        case .comedy: return "Comedy"
        case .thriller: return "Thriller"
        }
    }
}
