//
//  Credits.swift
//  TMDb
//
//  Created by Khalid Asad on 4/18/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import Foundation

struct CreditsResponse: Codable {
    var id: Int?
    var cast: [Cast]?
    var crew: [Crew]?
}

struct Cast: Codable {
    var castID: Int?
    var character: String?
    var creditID: String?
    var gender: Int?
    var id: Int?
    var name: String?
    var order: Int?
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender
        case id
        case name
        case order
        case profilePath = "profile_path"
    }
}

struct Crew: Codable {
    var creditID: String?
    var department: String?
    var gender: Int?
    var id: Int?
    var job: String?
    var name: String?
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department
        case gender
        case id
        case job
        case name
        case profilePath = "profile_path"
    }
}
