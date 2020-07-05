//
//  NetworkManager.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

final class NetworkManager: NetworkRequestProtocol {
    
    static let shared = NetworkManager(session: NetworkSession())
    
    var session: NetworkRequestProtocol
    
    init(session: NetworkRequestProtocol) {
        self.session = session
    }
    
    func fetchQuery(_ term: String, page: Int, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error>) -> Void) {
        session.fetchQuery(term, page: page, completion: completion)
    }
    
    func fetchCredits(for id: Int, completion: @escaping (FetchInfoState<CreditsResponse?, Error>) -> Void) {
        session.fetchCredits(for: id, completion: completion)
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        session.fetchImage(url: url, completion: completion)
    }
}
