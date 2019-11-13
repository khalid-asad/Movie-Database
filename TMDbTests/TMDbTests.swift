//
//  TMDbTests.swift
//  TMDbTests
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import XCTest
@testable import TMDb

class TMDbTests: XCTestCase {

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMovieSearchQueryObject() {
        if let data = getData(name: "queryResponse") {
            XCTAssertNotNil(data)
            do {
                let result = try JSONDecoder().decode(MovieSearchQuery.self, from: data)
                XCTAssertNotNil(result)
                
                XCTAssertEqual(result.page, 1)
                XCTAssertEqual(result.totalResults, 26)
                XCTAssertEqual(result.totalPages, 2)
                
                let results = result.results
                XCTAssertNotNil(results)
                
                XCTAssertEqual(results.count, 20)
                
                if let firstResult = results.first {
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
                    XCTAssertEqual(firstResult.releaseDate, "2001-11-16")
                } else {
                    XCTFail("There should be some data in the first result.")
                }
                
                if let lastResult = results.last {
                    XCTAssertNotNil(lastResult.id)
                } else {
                    XCTFail("There should be some data in the last result.")
                }
            } catch {
                XCTFail("Could not decode object.")
            }
        } else {
            XCTFail("Could not get JSON.")
        }
    }
    
    func testMovieModel() {
        let model = MovieModel()
        
        // Given a fake API key
        let baseURL = "https://api.themoviedb.org/3/search/movie?api_key="
        var apiKey = "0"
        let queryURL = "&query="
        let query = "Harry Potter"
        
        // When the query is a valid Percent encoded string
        var percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(percentEncodedQuery, "Harry%20Potter")
        
        var searchURL = baseURL + apiKey + queryURL + percentEncodedQuery
        
        var ex = expectation(description: "Waiting for fetch call to fail.")
        // Then the fetch query call should not fail, instead return 0 results
        model.fetchQuery(searchURL, completion: { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.results.count, 0)
                ex.fulfill()
            case .failure:
                XCTFail("This test case should not fail even though there is an incorrect API key.")
            }
        })
        self.wait(for: [ex], timeout: 5)
        
        // Given a valid API key
        apiKey = "2a61185ef6a27f400fd92820ad9e8537"
        searchURL = baseURL + apiKey + queryURL + percentEncodedQuery
        
        ex = expectation(description: "Waiting for fetch call to succeed.")
        // Then the fetch query call should pass
        model.fetchQuery(searchURL, completion: { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.results.count, 20)
                XCTAssertEqual(data?.page, 1)
                XCTAssertEqual(data?.totalResults, 26)
                XCTAssertEqual(data?.totalPages, 2)
                ex.fulfill()
            case .failure:
                XCTFail("This test case should not fail due to a correct API key.")
            }
        })
        wait(for: [ex], timeout: 10)
        
        // Given a valid API key and search term of ""
        apiKey = "2a61185ef6a27f400fd92820ad9e8537"
        percentEncodedQuery = "".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        searchURL = baseURL + apiKey + queryURL + percentEncodedQuery
        
        ex = expectation(description: "Waiting for fetch call to succeed.")
        // Then the fetch query call should pass
        model.fetchQuery(searchURL, completion: { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data?.results.count, 20)
                XCTAssertEqual(data?.page, 1)
                XCTAssertEqual(data?.totalResults, 26)
                XCTAssertEqual(data?.totalPages, 2)
                ex.fulfill()
            case .failure:
                XCTFail("This test case should not fail due to a correct API key.")
            }
        })
        wait(for: [ex], timeout: 10)
    }
}

extension XCTestCase {
    
    func getData(name: String, withExtension: String = "json") -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: name, withExtension: withExtension), let data = try? Data(contentsOf: fileUrl) else { return nil }
        return data
    }
}
