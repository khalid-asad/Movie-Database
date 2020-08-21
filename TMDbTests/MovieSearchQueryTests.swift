//
//  MovieSearchQueryTests.swift
//  TMDbTests
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import XCTest
@testable import TMDb
@testable import PlatformCommon

class MovieSearchQueryTests: XCTestCase {
    
    let baseURL = "https://api.themoviedb.org/3/search/movie?api_key="
    let queryURL = "&query="
    let query = "Harry Potter"
        
    func testMovieSearchQuerySuccess() {
        let session = MockNetworkRequest(file: "movie_search_query_success")
        let networkManager = NetworkManager(session: session)
        
        // Given a valid API key.
        let apiKey = "2a61185ef6a27f400fd92820ad9e8537"
        
        // When the query is a valid Percent encoded string.
        let percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(percentEncodedQuery, "Harry%20Potter")

        let searchURL = baseURL + apiKey + queryURL + percentEncodedQuery

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        
        // Then the fetch query call should pass with matching JSON results.
        networkManager.fetchQuery(searchURL, page: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.results.count, 20)
                XCTAssertEqual(data?.page, 1)
                XCTAssertEqual(data?.totalResults, 26)
                XCTAssertEqual(data?.totalPages, 2)
                
                guard let firstResult = data?.results.first else {
                    return XCTFail("There should be some data in the first result.")
                }
                
                XCTAssertEqual(firstResult.popularity, 47.276)
                XCTAssertEqual(firstResult.voteCount, 15029)
                XCTAssertEqual(firstResult.video, false)
                XCTAssertEqual(firstResult.posterPath, "/dCtFvscYcXQKTNvyyaQr2g2UacJ.jpg")
                XCTAssertEqual(firstResult.id, 671)
                XCTAssertEqual(firstResult.adult, false)
                XCTAssertEqual(firstResult.backdropPath, "/hziiv14OpD73u9gAak4XDDfBKa2.jpg")
                XCTAssertEqual(firstResult.originalLanguage, "en")
                XCTAssertEqual(firstResult.genreIDs, [12, 14, 10751])
                XCTAssertEqual(firstResult.title, "Harry Potter and the Philosopher's Stone")
                XCTAssertEqual(firstResult.voteAverage, 7.8)
                XCTAssertEqual(firstResult.overview, "Harry Potter has lived under the stairs at his aunt and uncle's house his whole life. But on his 11th birthday, he learns he's a powerful wizard -- with a place waiting for him at the Hogwarts School of Witchcraft and Wizardry. As he learns to harness his newfound powers with the help of the school's kindly headmaster, Harry uncovers the truth about his parents' deaths -- and about the villain who's to blame.")
                XCTAssertEqual(firstResult.releaseDate, "2001-11-16".toDate)
                
                if let lastResult = data?.results.last {
                    XCTAssertNotNil(lastResult.id)
                } else {
                    XCTFail("There should be some data in the last result.")
                }

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
        
        // Given a fake API key.
        let apiKey = "0"

        // When the query is a valid Percent encoded string.
        let percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(percentEncodedQuery, "Harry%20Potter")

        let searchURL = baseURL + apiKey + queryURL + percentEncodedQuery

        let ex = expectation(description: "Waiting for fetch call to fail.")
        
        networkManager.fetchQuery(searchURL, page: 1) { result in
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
        
        // Given a valid API key.
        let apiKey = "2a61185ef6a27f400fd92820ad9e8537"

        // When the query is a valid Percent encoded string.
        let percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(percentEncodedQuery, "Harry%20Potter")
        
        // Given a valid API key, incorrect URL, and search term of "".
        let searchURL = "https://www.fakestdfdsjfURL/" + apiKey + queryURL + percentEncodedQuery

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        // Then the fetch query call should fail.
        networkManager.fetchQuery(searchURL, page: 2) { result in
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
    
    func testMovieSearchQueryInvalidJSONFailure() {
        let session = MockNetworkRequest(file: "movie_search_query_invalid_json_failure")
        let networkManager = NetworkManager(session: session)
        
        // Given a valid API key.
        let apiKey = "2a61185ef6a27f400fd92820ad9e8537"
        
        // When the query is a valid Percent encoded string.
        let percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(percentEncodedQuery, "Harry%20Potter")

        // Given a valid API key, incorrect URL, and search term of "".
        let searchURL = baseURL + apiKey + queryURL + percentEncodedQuery

        let ex = expectation(description: "Waiting for fetch call to succeed.")
        // Then the fetch query call should fail.
        networkManager.fetchQuery(searchURL, page: 2) { result in
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
