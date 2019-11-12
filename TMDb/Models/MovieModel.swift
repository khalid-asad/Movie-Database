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
    
    var tableData: [AnyObject]!
    var cache: NSCache<AnyObject, AnyObject>!
    
    private var stackableItem: [MovieInfo] = [
        MovieInfo(name: "Terminator", date: "2019-07-05", image: "terminator"),
        MovieInfo(name: "Joker", date: "2019-07-05", image: "joker"),
        MovieInfo(name: "Reservoir Dogs", date: "2019-07-05", image: nil),
        MovieInfo(name: "Reservoir Dogs", date: "2019-07-05", image: nil),
        MovieInfo(name: "Reservoir Dogs", date: "2019-07-05", image: nil)
    ]
    
    var stackableItems: [MovieInfo] {
        return stackableItem
    }
    
    public enum StackableItems {
        case movie(name: String, date: String, image: UIImage?)
    }
}

public enum FetchInfoState<T> {
    case success
    case failure(T)
}

// MARK: - Network Requests
extension MovieModel {
    
    func fetchQuery(_ term: String, completion: @escaping (FetchInfoState<Error?>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(term)") else { return }
        URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (url: URL?, response: URLResponse?, error: Error?) -> Void in
            guard let self = self, let url = url else { return }
            do {
                guard let data = try? Data(contentsOf: url) else { return }
                let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                let result = dic.value(forKey : "results") as? [AnyObject]
                self.tableData = result
                completion(.success)
            } catch {
                print("Error: \(error)")
                completion(.failure(error))
            }
        }).resume()
    }
    
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
