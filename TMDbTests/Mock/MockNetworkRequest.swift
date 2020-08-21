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
@testable import PlatformCommon

final class MockNetworkRequest: NetworkRequestProtocol {
    
    var error: NetworkError?
    var file: String
    
    init(file: String, error: NetworkError? = nil) {
        self.file = file
        self.error = error
    }
    
    func fetchQuery(_ term: String, page: Int, completion: @escaping (Result<MovieSearchQuery?, Error>) -> Void) {
        if let error = error { return completion(.failure(error)) }
        MockJSONLoader().load(file, completion: completion)
    }

    func fetchCredits(for id: Int, completion: @escaping (Result<CreditsResponse?, NetworkError>) -> Void) {
        if let error = error { return completion(.failure(error)) }
        MockJSONLoader().load(file) { (result: Result<CreditsResponse?, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as! NetworkError))
            }
        }
    }

    func fetchMovieImageDetails(for id: Int, completion: @escaping (Result<MovieImages?, NetworkError>) -> Void) {
        if let error = error { return completion(.failure(error)) }
        MockJSONLoader().load(file) { (result: Result<MovieImages?, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as! NetworkError))
            }
        }
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        completion(nil)
    }
}
