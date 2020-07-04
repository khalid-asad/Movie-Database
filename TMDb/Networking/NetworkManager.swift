//
//  NetworkManager.swift
//  TMDb
//
//  Created by Khalid Asad on 7/4/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

final class NetworkManager: NetworkRequestProtocol {
    
    static let shared = NetworkManager()
    
    func fetchQuery(_ term: String, page: Int, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error?>) -> Void) {
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
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                DispatchQueue.main.async { completion(cellImage)}
            }).resume()
        }
    }
}
