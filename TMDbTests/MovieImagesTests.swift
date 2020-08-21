//
//  MovieImagesTests.swift
//  TMDbTests
//
//  Created by Khalid Asad on 7/7/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import XCTest
@testable import TMDb
@testable import PlatformCommon

class MovieImagesTests: XCTestCase {
            
    func testMovieImagesSuccess() {
        let session = MockNetworkRequest(file: "movie_images_success")
        let networkManager = NetworkManager(session: session)
        
        let ex = expectation(description: "Waiting for fetch call to succeed.")
        
        let id = 550
        
        // Then the fetch movie images call should pass with matching JSON results.
        networkManager.fetchMovieImageDetails(for: id) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.backdrops.count, 1)
                XCTAssertEqual(data?.posters.count, 1)
                XCTAssertEqual(data?.id, 550)
                
                guard let firstBackdrop = data?.backdrops.first else {
                    return XCTFail("There should be some data in the first cast result.")
                }
                
                XCTAssertEqual(firstBackdrop.aspectRatio, 1.77777777777778)
                XCTAssertEqual(firstBackdrop.filePath, "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")
                XCTAssertEqual(firstBackdrop.height, 720)
                XCTAssertNil(firstBackdrop.iso639_1)
                XCTAssertEqual(firstBackdrop.voteAverage, 0)
                XCTAssertEqual(firstBackdrop.voteCount, 0)
                XCTAssertEqual(firstBackdrop.width, 1280)
                
                guard let lastPoster = data?.posters.last else {
                    return XCTFail("There should be some data in the last crew result.")
                }
                
                XCTAssertEqual(lastPoster.aspectRatio, 0.666666666666667)
                XCTAssertEqual(lastPoster.filePath, "/fpemzjF623QVTe98pCVlwwtFC5N.jpg")
                XCTAssertEqual(lastPoster.height, 1800)
                XCTAssertEqual(lastPoster.iso639_1, "en")
                XCTAssertEqual(lastPoster.voteAverage, 0)
                XCTAssertEqual(lastPoster.voteCount, 0)
                XCTAssertEqual(lastPoster.width, 1200)

                ex.fulfill()
            case .failure:
                XCTFail("This test case should not fail due to a correct API key and good query.")
            }
        }
        wait(for: [ex], timeout: 1)
    }
    
    func testMovieImagesUnauthorizedFailure() {
        let session = MockNetworkRequest(file: "tmdb_invalid_api_key")
        let networkManager = NetworkManager(session: session)

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        let id = 671
        
        // Then the fetch movie images call should fail due to invalid JSON results.
        networkManager.fetchMovieImageDetails(for: id) { result in
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

    func testMovieImagesNotFoundFailure() {
        let session = MockNetworkRequest(file: "tmdb_url_not_found")
        let networkManager = NetworkManager(session: session)

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        let id = 671
        
        // Then the fetch movie images call should fail due to invalid JSON results.
        networkManager.fetchMovieImageDetails(for: id) { result in
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

    func testMovieImagesJSONDecodingFailure() {
        let session = MockNetworkRequest(file: "movie_images_json_decoding_failure")
        let networkManager = NetworkManager(session: session)

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        let id = 671
        
        // Then the fetch movie images call should fail due to invalid JSON results.
        networkManager.fetchMovieImageDetails(for: id) { result in
            switch result {
            case .success:
                XCTFail("This test case should fail due to an incorrectly parsed JSON.")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.unableToDecodeJSON.localizedDescription)
                ex.fulfill()
            }
        }
        wait(for: [ex], timeout: 1)
    }
}

