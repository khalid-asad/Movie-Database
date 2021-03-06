//
//  NetworkSession.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import enum PlatformCommon.NetworkError
import UIKit

final class NetworkSession: NetworkRequestProtocol {    
        
    func fetchQuery(_ term: String, page: Int, completion: @escaping (Result<MovieSearchQuery?, Error>) -> Void) {
        guard let url = URL(string: StringKeyFormatter.searchURL(query: term, page: page).rawValue) else {
            return completion(.failure(NetworkError.invalidURL))
        }

        DispatchQueue.network.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noData)) }
                    return
                }

                do {
                    let responseData = try JSONDecoder().decode(MovieSearchQuery.self, from: data)
                    DispatchQueue.main.async { completion(.success(responseData)) }
                } catch _ {
                    var error: Error
                    do {
                        let result = try JSONDecoder().decode(StatusResponse.self, from: data)
                        error = result.error
                    } catch _ {
                        error = NetworkError.unableToDecodeJSON
                    }
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        }
    }
    
    func fetchCredits(for id: Int, completion: @escaping (Result<CreditsResponse?, NetworkError>) -> Void) {
        CreditsRequest(id: id)
            .fetch(completion: completion)
    }
    
    func fetchMovieImageDetails(for id: Int, completion: @escaping (Result<MovieImages?, NetworkError>) -> Void) {
        MovieImageDetailsRequest(id: id)
            .fetch(completion: completion)
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.network.async {
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let data = try? Data(contentsOf: url), let cellImage = UIImage(data: data) else {
                    return DispatchQueue.main.async { completion(nil) }
                }
                DispatchQueue.main.async { completion(cellImage)}
            }).resume()
        }
    }
}
