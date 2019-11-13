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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

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
                
                let firstResult = results.first
                XCTAssertEqual(firstResult?.popularity, 47.276)
                XCTAssertEqual(firstResult?.voteCount, 15029)
                XCTAssertEqual(firstResult?.video, false)
                XCTAssertEqual(firstResult?.posterPath, "/dCtFvscYcXQKTNvyyaQr2g2UacJ.jpg")
                XCTAssertEqual(firstResult?.id, 671)
                XCTAssertEqual(firstResult?.adult, false)
                XCTAssertEqual(firstResult?.backdropPath, "/hziiv14OpD73u9gAak4XDDfBKa2.jpg")
                XCTAssertEqual(firstResult?.originalLanguage, "en")
                XCTAssertEqual(firstResult?.genreIDs, [12, 14, 10751])
                XCTAssertEqual(firstResult?.title, "Harry Potter and the Philosopher's Stone")
                XCTAssertEqual(firstResult?.voteAverage, 7.8)
                XCTAssertEqual(firstResult?.overview, "Harry Potter has lived under the stairs at his aunt and uncle's house his whole life. But on his 11th birthday, he learns he's a powerful wizard -- with a place waiting for him at the Hogwarts School of Witchcraft and Wizardry. As he learns to harness his newfound powers with the help of the school's kindly headmaster, Harry uncovers the truth about his parents' deaths -- and about the villain who's to blame.")
                XCTAssertEqual(firstResult?.releaseDate, "2001-11-16")

            } catch {
                XCTFail("Could not decode object.")
            }
        } else {
            XCTFail("Could not get JSON.")
        }
    }
}

extension XCTestCase {
    
    func getData(name: String, withExtension: String = "json") -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: name, withExtension: withExtension), let data = try? Data(contentsOf: fileUrl) else { return nil }
        return data
    }
}
