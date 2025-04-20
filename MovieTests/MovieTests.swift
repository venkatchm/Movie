//
//  MovieTests.swift
//  MovieTests
//
//  Created by G Arthi on 21/02/25.
//

import XCTest
@testable import Movie

final class MovieTests: XCTestCase {
    var viewModel:ContentView.ViewModel!

//    override func setUpWithError() throws {
//        super.setUp()
//        Task {
//            viewModel = await ContentView.ViewModel()
//
//        }
//    }
    
    override func setUp() async throws {
       try await super.setUp()
        viewModel = await ContentView.ViewModel()

    }
    
    override func tearDown() async throws {
                viewModel = nil
        try await super.tearDown()
    }
    
    func testView() async throws {
//        #expect(viewModel != nil)
        XCTAssertTrue(viewModel != nil)
    }

//    override func tearDownWithError() throws {
//        viewModel = nil
//        super.tearDown()
//    }

    func testMovieDecoding() {
            let json = """
            {
                "results": [
                    {
                        "id": 1,
                        "original_title": "Sample Movie",
                        "original_language": "en",
                        "adult": false,
                        "overview": "This is a sample movie overview.",
                        "poster_path": "/sample.jpg",
                        "release_date": "2025-02-21"
                    }
                ]
            }
            """
            let data = Data(json.utf8)
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MovieResponse.self, from: data)
                XCTAssertEqual(response.results.count, 1)
                XCTAssertEqual(response.results.first?.originalTitle, "Sample Movie")
            } catch {
                XCTFail("Failed to decode MovieResponse: \(error)")
            }
        }
    }


