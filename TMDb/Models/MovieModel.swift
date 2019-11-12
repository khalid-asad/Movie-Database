//
//  MovieModel.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

final class MovieModel {
    
    private var stackableItem: [MovieInfo] = [
        MovieInfo(name: "Terminator", date: "2019-07-05", image: "terminator"),
        MovieInfo(name: "Joker", date: "2019-07-05", image: "joker"),
        MovieInfo(name: "Reservoir Dogs", date: "2019-07-05", image: nil),
        MovieInfo(name: "Reservoir Dogs", date: "2019-07-05", image: nil),
        MovieInfo(name: "Reservoir Dogs", date: "2019-07-05", image: nil)
    ]
    
    var stackableItems: [MovieInfo] {
        return stackableItem
    }
    
    public enum StackableItems {
        case movie(name: String, date: String, image: UIImage?)
    }
}
