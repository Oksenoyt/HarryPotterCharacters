//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Oksenoyt on 13.10.2023.
//

import XCTest
@testable import HarryPotterСharacters

final private class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testGetCharactersSuccess() {
        let expectation = self.expectation(description: "Characters fetch successful")
        sut.getCharacters { result in
            switch result {
            case .success(let characters):
                XCTAssertGreaterThan(characters.count, 0, "Characters list should not be empty on success")
                XCTAssertTrue(characters.allSatisfy { !$0.image.isEmpty }, "All characters should have non-empty image URLs")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected successful characters fetch, but got error: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetSpellsSuccess() {
        let expectation = self.expectation(description: "Spells fetch successful")
        sut.getSpells { result in
            switch result {
            case .success(let spells):
                XCTAssertGreaterThan(spells.count, 0, "Spells list should not be empty on success")
                XCTAssertTrue(spells.allSatisfy { !$0.name.isEmpty && !$0.description.isEmpty }, "All spells should have non-empty names and descriptions")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected successful spells fetch, but got error: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchImageSuccess() {
        let imageUrl = URL(string: "https://ik.imagekit.io/hpapi/harry.jpg")!
        let expectation = self.expectation(description: "Image fetch successful")
        sut.fetchImage(from: imageUrl) { result in
            switch result {
            case .success(let imageData):
                XCTAssertGreaterThan(imageData.count, 0, "Image data should not be empty on success")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected successful image fetch, but got error: \(error)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchImageFailure() {
        let invalidImageUrl = URL(string: "https://example.com/image.jpg")!
        let expectation = self.expectation(description: "Image fetch should fail")
        sut.fetchImage(from: invalidImageUrl) { result in
            switch result {
            case .success(_):
                XCTFail("Expected image fetch to fail, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .noDate, "Expected failure with .noDate error")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
