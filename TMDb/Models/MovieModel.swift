//
//  MovieModel.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Movie Model Class
final class MovieModel {
    
    var items: [MovieSearchResult]!
    var cache: NSCache<AnyObject, AnyObject>!
}

public enum FetchInfoState<T, U> {
    case success(T)
    case failure(U)
}

// MARK: - Network Requests
extension MovieModel: NetworkRequestProtocol {
    
    // Fetch the query search term against the API through URLSession downloadTask
    func fetchQuery(_ term: String, page: Int? = nil, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error?>) -> Void) {
        let page = page ?? ((items.count / 20) + 1)
        
        guard let url = URL(string: StringKeyFormatter.searchURL(query: term, page: page).rawValue) else {
            return completion(.failure(nil))
        }
        
        DispatchQueue.network.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(nil)) }
                    return
                }
                
                do {
                    let responseData = try JSONDecoder().decode(MovieSearchQuery.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {
                            return completion(.failure(nil))
                        }
                        self.items = page == 1 ? responseData.results : self.items + responseData.results
                        completion(.success(responseData))
                    }
                } catch let err {
                    print("Err", err)
                    DispatchQueue.main.async { completion(.failure(err)) }
                }
            }.resume()
        }
    }
    
    // Download the image
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.network.async {
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let data = try? Data(contentsOf: url), let cellImage = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                DispatchQueue.main.async { completion(cellImage)}
            }).resume()
        }
    }
}
