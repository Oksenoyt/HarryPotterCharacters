//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Oksenoyt on 13.10.2023.
//

import XCTest
@testable import HarryPotterСharacters

final class NetworkManagerTests: XCTestCase {
    private var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testDecoding() throws {
        /// When the Data initializer is throwing an error, the test will fail.
        let jsonData = try Data(contentsOf: URL(string: "user.json")!)

        /// The `XCTAssertNoThrow` can be used to get extra context about the throw
        XCTAssertNoThrow(try JSONDecoder().decode(Character.self, from: jsonData))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
