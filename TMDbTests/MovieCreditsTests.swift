//
//  MovieCreditsTests.swift
//  TMDbTests
//
//  Created by Khalid Asad on 7/5/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import XCTest
@testable import TMDb

class MovieCreditsTests: XCTestCase {
            
    func testMovieCreditsSuccess() {
        let session = MockNetworkRequest(file: "movie_cast_success")
        let networkManager = NetworkManager(session: session)
        
        let ex = expectation(description: "Waiting for fetch call to succeed.")
        
        let id = 671
        
        // Then the fetch credits call should pass with matching JSON results.
        networkManager.fetchCredits(for: id) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.cast?.count, 60)
                XCTAssertEqual(data?.id, 671)
                
                guard let firstResult = data?.cast?.first else {
                    return XCTFail("There should be some data in the first cast result.")
                }
                
                XCTAssertEqual(firstResult.gender, 2)
                XCTAssertEqual(firstResult.character, "Harry Potter")
                XCTAssertEqual(firstResult.id, 10980)
                XCTAssertEqual(firstResult.order, 0)
                XCTAssertEqual(firstResult.castID, 27)
                XCTAssertEqual(firstResult.profilePath, "/j0A7iK2wIQ1NWwJVVaTegMmKgR.jpg")
                XCTAssertEqual(firstResult.name, "Daniel Radcliffe")
                XCTAssertEqual(firstResult.creditID, "52fe4267c3a36847f801be91")
                
                guard let lastResult = data?.crew?.last else {
                    return XCTFail("There should be some data in the last crew result.")
                }
                
                XCTAssertEqual(lastResult.gender, 0)
                XCTAssertNil(lastResult.profilePath)
                XCTAssertEqual(lastResult.id, 2233062)
                XCTAssertEqual(lastResult.job, "Rotoscoping Artist")
                XCTAssertEqual(lastResult.department, "Visual Effects")
                XCTAssertEqual(lastResult.name, "Martin Cook")
                XCTAssertEqual(lastResult.creditID, "5c55e9a692514157df4e96d5")
                
                ex.fulfill()
            case .failure:
                XCTFail("This test case should not fail due to a correct API key and good query.")
            }
        }
        wait(for: [ex], timeout: 1)
    }
    
    func testMovieSearchQueryUnauthorizedFailure() {
        let session = MockNetworkRequest(file: "tmdb_invalid_api_key")
        let networkManager = NetworkManager(session: session)

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        let id = 671
        
        // Then the fetch credits call should fail due to invalid JSON results.
        networkManager.fetchCredits(for: id) { result in
            switch result {
            case .success:
                XCTFail("This test case should fail because there is an incorrect API key.")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidAPIKey.localizedDescription)
                ex.fulfill()
            }
        }
        wait(for: [ex], timeout: 1)
    }

    func testMovieSearchQueryURLNotFoundFailure() {
        let session = MockNetworkRequest(file: "tmdb_url_not_found")
        let networkManager = NetworkManager(session: session)

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        let id = 671
        
        // Then the fetch credits call should fail due to invalid JSON results.
        networkManager.fetchCredits(for: id) { result in
            switch result {
            case .success:
                XCTFail("This test case should fail due to an incorrect URL.")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.notFound.localizedDescription)
                ex.fulfill()
            }
        }
        wait(for: [ex], timeout: 1)
    }

    func testMovieCreditsInvalidJSONFailure() {
        let session = MockNetworkRequest(file: "movie_cast_invalid_json_failure")
        let networkManager = NetworkManager(session: session)

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        let id = 671
        
        // Then the fetch credits call should fail due to invalid JSON results.
        networkManager.fetchCredits(for: id) { result in
            switch result {
            case .success:
                XCTFail("This test case should fail due to an incorrectly parsed JSON.")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidJSONResponse.localizedDescription)
                ex.fulfill()
            }
        }
        wait(for: [ex], timeout: 1)
    }
}

