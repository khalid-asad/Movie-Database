//
//  MovieModel.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import enum PlatformCommon.NetworkError
import UIKit

// MARK: - Movie Model Class
final class MovieModel {
    
    var items: [MovieSearchResult]!
    var cache: NSCache<AnyObject, AnyObject>!
}

// MARK: - Network Requests
extension MovieModel {
    
    /// Fetch the query search term against the API through URLSession downloadTask.
    func fetchQuery(_ term: String, page: Int? = nil, completion: @escaping (Result<MovieSearchQuery?, Error>) -> Void) {
        let page = page ?? ((items.count / 20) + 1)
        NetworkManager.shared.fetchQuery(term, page: page) { [weak self] result in
            guard let self = self else { return completion(.failure(NetworkError.noReference)) }
            if case .success(let response) = result {
                guard let response = response else { return completion(.failure(NetworkError.emptyResponse)) }
                self.items = page == 1 ? response.results : self.items + response.results
            }
            completion(result)
        }
    }
    
    /// Download the image.
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.fetchImage(url: url, completion: completion)
    }
}
