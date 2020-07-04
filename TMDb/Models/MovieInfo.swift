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
    var releaseDate: Date?
    
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        popularity = try container.decode(Double.self, forKey: .popularity)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        video = try container.decode(Bool.self, forKey: .video)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        id = try container.decode(Int.self, forKey: .id)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        genreIDs = try container.decode([Int].self, forKey: .genreIDs)
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        overview = try container.decode(String.self, forKey: .overview)
        
        let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = releaseDateString?.toDate
    }
}

enum Genres: Int, CaseIterable, Codable {
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
