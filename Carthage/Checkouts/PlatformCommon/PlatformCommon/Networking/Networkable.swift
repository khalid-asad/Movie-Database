//
//  Networkable.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

/// A wrapper to easily handle and organize Network Requests.
public protocol Networkable: Codable, Hashable {
    
    /// The optional API Key String for the request.
    var apiKey: String? { get }
    
    /// The base URL in String format.
    var baseURL: String { get }
    
    /// The HTTP Headers of the request as a String Dictionary.
    var httpHeaders: [String: String]? { get }
    
    /// Determines if the request will handle cookies.
    var httpShouldHandleCookies: Bool { get }
    
    /// The optional remaining URL path as a String.
    var urlPath: String? { get }
    
    /// The optional Query Parameters as an array of String Dictionaries.
    var queryParameters: [[String: String]]? { get }
    
    /// The Network Request Type. Default is GET.
    var requestType: NetworkRequestType { get }
    
    /// The main Network Request handler function.
    /// - parameter session: A URL Session that can be mocked. Default is shared.
    /// - parameter completion: The Result of the network call as a Response object given for success or a Network Error for failure.
    func fetch<T: Decodable>(session: URLSession, completion: @escaping (Result<T, NetworkError>) -> Void)
}

// MARK: - Default Implementation of Computed Variables.
public extension Networkable {
    
    var apiKey: String? { nil }
    
    var httpHeaders: [String: String]? { nil }
    
    var httpShouldHandleCookies: Bool { false }
    
    var queryParameters: [[String: String]]? { nil }
    
    var request: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.httpShouldHandleCookies = httpShouldHandleCookies
        
        if let allHTTPHeaderFields = httpHeaders {
            request.allHTTPHeaderFields = allHTTPHeaderFields
        }
        
        if let queryParameters = queryParameters,
            let httpBody = try? JSONSerialization.data(withJSONObject: queryParameters, options: [.prettyPrinted]) {
            request.httpBody = httpBody
        }
        
        return request
    }
    
    var requestType: NetworkRequestType { .get }
    
    var url: URL? {
        urlComponents?.url
    }
    
    var urlComponents: URLComponents? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        
        if let urlPath = urlPath {
            components.path = urlPath
        }
        
        if let apiKey = apiKey {
            components.query = apiKey
        }
        
        return components
    }
    
    var urlPath: String? { nil }
}

// MARK: - The public facing Network Fetch function.
public extension Networkable {
    
    func fetch<T: Decodable>(session: URLSession = .shared, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = request else { return completion(.failure(.invalidURL)) }
        DispatchQueue.network.async {
            session.dataTask(with: request) { (data, response, error) in
                do {
                    guard let httpURLResponse = response as? HTTPURLResponse,
                        200...299 ~= httpURLResponse.statusCode
                    else { throw NetworkError.invalidHTTPResponse }
                    
                    guard let data = data else { throw NetworkError.noData }
                    
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async { completion(.success(decodedResponse)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error as? NetworkError ?? .unknown)) }
                }
            }
        }
    }
}
