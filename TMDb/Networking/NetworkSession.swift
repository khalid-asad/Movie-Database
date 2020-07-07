//
//  NetworkSession.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

final class NetworkSession: NetworkRequestProtocol {
        
    func fetchQuery(_ term: String, page: Int, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error>) -> Void) {
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
    
    func fetchCredits(for id: Int, completion: @escaping (FetchInfoState<CreditsResponse?, Error>) -> Void) {
        guard let url = URL(string: StringKeyFormatter.creditsURL(id: id).rawValue) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        DispatchQueue.network.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return DispatchQueue.main.async { completion(.failure(NetworkError.noData)) }
                }
                
                do {
                    let responseData = try JSONDecoder().decode(CreditsResponse.self, from: data)
                    DispatchQueue.main.async { completion(.success(responseData)) }
                } catch let err {
                    print("Err", err)
                    DispatchQueue.main.async { completion(.failure(err)) }
                }
            }.resume()
        }
    }
    
    func fetchMovieImageDetails(for id: Int, completion: @escaping (FetchInfoState<MovieImages?, Error>) -> Void) {
        guard let url = URL(string: StringKeyFormatter.movieImageDetailsURL(id: id).rawValue) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        DispatchQueue.network.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return DispatchQueue.main.async { completion(.failure(NetworkError.noData)) }
                }
                
                do {
                    let responseData = try JSONDecoder().decode(MovieImages.self, from: data)
                    DispatchQueue.main.async { completion(.success(responseData)) }
                } catch let err {
                    print("Err", err)
                    DispatchQueue.main.async { completion(.failure(err)) }
                }
            }.resume()
        }
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
