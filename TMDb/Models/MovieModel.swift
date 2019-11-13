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

public enum FetchInfoState<T> {
    case success
    case failure(T)
}

// MARK: - Network Requests
extension MovieModel {
    
    // Fetch the query search term against the API through URLSession downloadTask
    func fetchQuery(_ term: String, completion: @escaping (FetchInfoState<Error?>) -> Void) {
        guard let url = URL(string: StringKeyFormatter.searchURL(query: term).rawValue) else {
            completion(.failure(nil))
            return
        }
        
        URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (url: URL?, response: URLResponse?, error: Error?) -> Void in
            guard let self = self, let url = url else { return }
            do {
                guard let data = try? Data(contentsOf: url) else {
                    completion(.failure(nil))
                    return
                }
                
                // Decode the JSON into a Codable object of MovieSearchQuery
                let result = try JSONDecoder().decode(MovieSearchQuery.self, from: data)
                dump(result)
                
                // Set the items variable in the class and return
                self.items = result.results
                completion(.success)
            } catch {
                print("Error: \(error)")
                completion(.failure(error))
            }
        }).resume()
    }
    
    // Download the image
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            guard let data = try? Data(contentsOf: url), let cellImage = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(cellImage)
        }).resume()
    }
}
