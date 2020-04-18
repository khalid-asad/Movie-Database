//
//  MockNetworkRequest.swift
//  TMDbTests
//
//  Created by Khalid Asad on 11/13/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import XCTest
@testable import TMDb

class MockNetworkRequest: NetworkRequestProtocol {
    
    var error: MockError?
    
    enum MockError: Error {
        case unauthorized
        case notFound
        case other
    }
    
    init(error: MockError? = nil) {
        self.error = error
    }
    
    func fetchQuery(_ term: String, page: Int, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error?>) -> Void) {
        guard let error = error else {
            if let path = Bundle(for: type(of: self)).path(forResource: "queryResponse", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let result = try JSONDecoder().decode(MovieSearchQuery.self, from: data)
                    completion(.success(result))
                    return
                } catch {
                    print("Mocking Error.")
                }
            }
            completion(.success(nil))
            return
        }
        
        if error == .unauthorized {
            if let path = Bundle(for: type(of: self)).path(forResource: "unauthorized", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let statusCode = jsonResult["status_code"] as? Int, statusCode == 7 {
                        completion(.failure(MockError.unauthorized))
                        return
                    }
                    completion(.failure(MockError.other))
                    return
                } catch {
                    print("Mocking Error.")
                }
            }
        } else if error == .notFound {
            if let path = Bundle(for: type(of: self)).path(forResource: "notFound", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let statusCode = jsonResult["status_code"] as? Int, statusCode == 34 {
                        completion(.failure(MockError.notFound))
                        return
                    }
                    completion(.failure(MockError.other))
                    return
                } catch {
                    print("Mocking Error.")
                }
            }
        }
        completion(.failure(MockError.other))
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        completion(nil)
    }
}
