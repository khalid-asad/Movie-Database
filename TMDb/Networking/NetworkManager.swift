//
//  NetworkManager.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import enum PlatformCommon.NetworkError
import UIKit

final class NetworkManager: NetworkRequestProtocol {
    
    static let shared = NetworkManager(session: NetworkSession())
    
    var session: NetworkRequestProtocol
    
    init(session: NetworkRequestProtocol) {
        self.session = session
    }
    
    func fetchQuery(_ term: String, page: Int, completion: @escaping (Result<MovieSearchQuery?, Error>) -> Void) {
        session.fetchQuery(term, page: page, completion: completion)
    }
    
    func fetchCredits(for id: Int, completion: @escaping (Result<CreditsResponse?, NetworkError>) -> Void) {
        session.fetchCredits(for: id) {
            switch $0 {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as NetworkError))
            }
        }
    }
    
    func fetchMovieImageDetails(for id: Int, completion: @escaping (Result<MovieImages?, NetworkError>) -> Void) {
        session.fetchMovieImageDetails(for: id, completion: completion)
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        session.fetchImage(url: url, completion: completion)
    }
}
