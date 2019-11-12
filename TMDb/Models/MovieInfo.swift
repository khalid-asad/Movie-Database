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
