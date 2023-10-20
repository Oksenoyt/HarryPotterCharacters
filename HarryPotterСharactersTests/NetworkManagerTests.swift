//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Oksenoyt on 13.10.2023.
//

import XCTest
@testable import HarryPotterСharacters

class NetworkManagerTests: XCTestCase {
    var mockSession: MockURLSession!
    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()

        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        networkManager = nil

        super.tearDown()
    }

    func testGetCharactersSuccess() {
        var fetchedCharacters: [Character]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching characters from mock")
        
        if let url = Bundle(for: type(of: self)).url(forResource: "CharacterResponse", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            mockSession.data = data
        }
        
        networkManager.getCharacters { result in
            switch result {
            case .success(let characters):
                fetchedCharacters = characters
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(fetchedCharacters)
        XCTAssertEqual(fetchedCharacters?.first?.name, "Harry Potter")
        XCTAssertNil(fetchedError)
    }

    func testGetCharactersFilteringSuccess() {
        var fetchedCharacters: [Character]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching characters and filtering by image")

        if let url = Bundle(for: type(of: self)).url(forResource: "CharacterResponse", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            mockSession.data = data
        }

        networkManager.getCharacters { result in
            switch result {
            case .success(let characters):
                fetchedCharacters = characters
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(fetchedCharacters)
        XCTAssertEqual(fetchedCharacters?.count, 1)
        XCTAssertEqual(fetchedCharacters?.first?.name, "Harry Potter")
        XCTAssertNil(fetchedError)
    }

    func testGetCharactersFailureNoDate() {
        mockSession.error = NetworkError.noDate
        mockSession.data = nil

        var fetchedCharacters: [Character]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching characters with noDate error")

        networkManager.getCharacters { result in
            switch result {
            case .success(let characters):
                fetchedCharacters = characters
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNil(fetchedCharacters)
        XCTAssertEqual(fetchedError, NetworkError.noDate)
    }

    func testGetCharactersFailureDecodingError() {
        let invalidJSONData = "{\"invalid\": \"data\"}".data(using: .utf8)!
        mockSession.data = invalidJSONData

        var fetchedCharacters: [Character]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching characters with decoding error")

        networkManager.getCharacters { result in
            switch result {
            case .success(let characters):
                fetchedCharacters = characters
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNil(fetchedCharacters)
        XCTAssertEqual(fetchedError, NetworkError.decodingError)
    }

    func testGetSpellsSuccess() {
        var fetchedSpells: [Spell]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching spells successfully")

        if let url = Bundle(for: type(of: self)).url(forResource: "SpellResponse", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            mockSession.data = data
        }

        networkManager.getSpells { result in
            switch result {
            case .success(let spells):
                fetchedSpells = spells
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(fetchedSpells)
        XCTAssertEqual(fetchedSpells?.first?.name, "Aberto")
        XCTAssertNil(fetchedError)
    }

    func testGetSpellsFailureNoDate() {
        mockSession.error = NetworkError.noDate
        mockSession.data = nil

        var fetchedSpells: [Spell]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching spells with noDate error")

        networkManager.getSpells { result in
            switch result {
            case .success(let spells):
                fetchedSpells = spells
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNil(fetchedSpells)
        XCTAssertEqual(fetchedError, NetworkError.noDate)
    }

    func testGetSpellsFailureDecodingError() {
        let invalidJSONData = "{\"invalid\": \"data\"}".data(using: .utf8)!
        mockSession.data = invalidJSONData

        var fetchedSpells: [Spell]?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching spells with decoding error")

        networkManager.getSpells { result in
            switch result {
            case .success(let spells):
                fetchedSpells = spells
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNil(fetchedSpells)
        XCTAssertEqual(fetchedError, NetworkError.decodingError)
    }

    func testFetchImageSuccessWithRelativePath() {
        guard let relativePath = Bundle(for: type(of: self)).path(forResource: "harry", ofType: "png"),
              let mockImage = UIImage(contentsOfFile: relativePath),
              let mockImageData = mockImage.jpegData(compressionQuality: 1.0) else {
            XCTFail("Failed to load the mock image or its data")
            return
        }

        let mockImageURL = URL(fileURLWithPath: relativePath)
        mockSession.data = mockImageData

        var fetchedImageData: Data?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching image successfully")

        networkManager.fetchImage(from: mockImageURL) { result in
            switch result {
            case .success(let data):
                fetchedImageData = data
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(fetchedImageData)
        XCTAssertNil(fetchedError)
    }

    func testFetchImageFailure() {
        let invalidImageURL = URL(string: "https://invalid.url")!

        var fetchedImageData: Data?
        var fetchedError: NetworkError?

        let expectation = self.expectation(description: "Fetching image with error")

        networkManager.fetchImage(from: invalidImageURL) { result in
            switch result {
            case .success(let data):
                fetchedImageData = data
            case .failure(let error):
                fetchedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNil(fetchedImageData)
        XCTAssertEqual(fetchedError, NetworkError.noDate)
    }
}
