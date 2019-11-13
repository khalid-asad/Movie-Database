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
    
    var items: [AnyObject]!
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
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=\(term)") else { return }
        URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (url: URL?, response: URLResponse?, error: Error?) -> Void in
            guard let self = self, let url = url else { return }
            do {
                guard let data = try? Data(contentsOf: url) else { return }
                let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                let result = dic.value(forKey : "results") as? [AnyObject]
                self.items = result
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
