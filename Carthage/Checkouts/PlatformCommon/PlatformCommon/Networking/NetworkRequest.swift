//
//  NetworkRequest.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 2019-06-24.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

/// The state of the network request fetching.
public enum FetchInfoState {
    case fetching
    case success
    case failure
}

/// The manager of Network Requests in an application.
public final class NetworkRequest {
    
    /// Handles a network request of any response type.
    /// - parameter session: The URL Session mocked or singleton object.
    /// - parameter url: The URL to initiate the network request from.
    /// - parameter completion: Callback that returns a Result with a response type indicated if successful, otherwise an error.
    public func fetchData<T: Decodable>(with session: URLSession = .shared, for url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            return completion(.failure(NetworkError.invalidURL))
        }
        session.dataTask(with: url) { (data, _, error) in
            if let error = error { return completion(.failure(error)) }
            guard let data = data else { return completion(.failure(NetworkError.noData)) }
            print("Data: \(data)")
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                dump(responseData)
                completion(.success(responseData))
            } catch {
                print("Err", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Handles a image download.
    /// - parameter session: The URL Session mocked or singleton object.
    /// - parameter url: The URL to initiate the network request from.
    /// - parameter completion: Callback that returns a Result with an image if successful, otherwise an error.
    public func downloadImage(with session: URLSession = .shared, url: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = url else { return completion(.failure(NetworkError.invalidURL)) }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, _, error) in
            if let error = error { return completion(.failure(error)) }
            guard let data = data, let image = UIImage(data: data) else {
                return completion(.failure(NetworkError.noData))
            }
            completion(.success(image))
        }.resume()
    }
}
