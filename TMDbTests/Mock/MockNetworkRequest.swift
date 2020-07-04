//
//  MockNetworkRequest.swift
//  TMDbTests
//
//  Created by Khalid Asad on 11/13/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import XCTest
@testable import TMDb

final class MockNetworkRequest: NetworkRequestProtocol {
    
    var error: NetworkError?
    var file: String
    
    init(file: String, error: NetworkError? = nil) {
        self.file = file
        self.error = error
    }
    
    func fetchQuery(_ term: String, page: Int, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error>) -> Void) {
        if let error = error { return completion(.failure(error)) }
        MockJSONLoader().load(file, completion: completion)
    }
        
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        completion(nil)
    }
}
