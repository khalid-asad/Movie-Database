//
//  DispatchQueue+Extensions.swift
//  TMDb
//
//  Created by Khalid Asad on 4/17/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static let network = DispatchQueue(label: "tmdb.network", qos: .background)
}
