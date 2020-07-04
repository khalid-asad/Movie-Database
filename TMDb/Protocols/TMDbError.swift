//
//  TMDbError.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import Foundation

/// An error unique to TMDb
protocol TMDbError: LocalizedError {
    
    /// The readable error message.
    var message: String { get }
}

extension TMDbError {
    
    var localizedDescription: String { message }
    var errorDescription: String? { message }
}
