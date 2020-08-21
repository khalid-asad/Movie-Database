//
//  MockJSONLoader.swift
//  TMDbTests
//
//  Created by Khalid Asad on 7/1/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

@testable import TMDb
@testable import PlatformCommon

final class MockJSONLoader {
    
    func loadLocalJSON(file: String, completion: @escaping (Any?) -> Void) {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else {
            return completion(nil)
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: pathString), options: .mappedIfSafe)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            completion(jsonData)
        } catch {
            completion(nil)
        }
    }
    
    /// Loads the local Mocked JSON object into a generic result.
    func load<T: Decodable>(_ file: String, completion: @escaping (Result<T, Error>) -> Void) {
        MockJSONLoader().loadLocalJSON(file: file) { json in
            guard let json = json else { return completion(.failure(NetworkError.invalidJSONResponse)) }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: json)
            } catch {
                return completion(.failure(NetworkError.invalidJSONResponse))
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(result))
            } catch {
                do {
                    let result = try JSONDecoder().decode(StatusResponse.self, from: jsonData)
                    completion(.failure(result.error))
                } catch {
                    completion(.failure(NetworkError.unableToDecodeJSON))
                }
            }
        }
    }
}
