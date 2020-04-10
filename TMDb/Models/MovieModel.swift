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
    func fetchQuery(_ term: String, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error?>) -> Void) {
        guard let url = URL(string: StringKeyFormatter.searchURL(query: term).rawValue) else {
            return completion(.failure(nil))
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data else {
                return completion(.failure(nil))
            }
            
            do {
                let responseData = try JSONDecoder().decode(MovieSearchQuery.self, from: data)
                self.items = responseData.results
                completion(.success(responseData))
            } catch let err {
                print("Err", err)
                completion(.failure(err))
            }
        }.resume()
    }
    
    // Download the image
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            guard let data = try? Data(contentsOf: url), let cellImage = UIImage(data: data) else {
                return completion(nil)
            }
            completion(cellImage)
        }).resume()
    }
}
