//
//  MovieImages.swift
//  TMDb
//
//  Created by Khalid Asad on 7/5/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import Foundation

struct MovieImages: Codable {
    let id: Int
    let backdrops, posters: [ImageDetails]
}

struct ImageDetails: Codable {
    let aspectRatio: Double?
    let filePath: String
    let height: Int?
    let iso639_1: String?
    let voteAverage: Double?
    let voteCount: Int?
    let width: Int?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso639_1 = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
