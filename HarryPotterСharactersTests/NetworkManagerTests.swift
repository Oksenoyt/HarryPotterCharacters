//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Oksenoyt on 13.10.2023.
//

import XCTest
@testable import HarryPotterСharacters

private class NetworkManagerTests: XCTestCase {
    var mockNetworking: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworking = MockNetworkManager()
    }

    override func tearDown() {
        mockNetworking = nil
        super.tearDown()
    }

    func testGetCharactersSuccess() {
        let expectedData: [Character]? = createArray(fromResource: "CharacterResponse")
        mockNetworking.mockedCharacters = expectedData

        var actualData: [Character]?
        var receivedError: NetworkError?

        mockNetworking.getCharacters { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNil(receivedError)
        XCTAssertEqual(actualData, expectedData, "The actual result \(String(describing: actualData)) differs from the expected one \(String(describing: expectedData))")
    }

    func testGetCharactersFilteringSuccess() {

    }

    func testGetCharactersFailureNoDate() {
        var receivedError: NetworkError?
        var actualData: [Character]?
        mockNetworking.mockedCharacters = []

        mockNetworking.getCharacters { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noDate, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(actualData)
    }

    func testGetCharactersFailureDecodingError() {
        var actualData: [Character]?
        var receivedError: NetworkError?
        mockNetworking.shouldReturnError = true

        mockNetworking.getCharacters { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }

    func testGetSpellsSuccess() {
        let expectedData: [Spell]? = createArray(fromResource: "SpellResponse")
        mockNetworking.mockedSpells = expectedData

        var actualData: [Spell]?
        var receivedError: NetworkError?

        mockNetworking.getSpells { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNil(receivedError)
        XCTAssertEqual(actualData, expectedData, "The actual result \(String(describing: actualData)) differs from the expected one \(String(describing: expectedData))")
    }

    func testGetSpellsFailureNoDate() {
        var receivedError: NetworkError?
        var actualData: [Spell]?

        mockNetworking.mockedSpells = []

        mockNetworking.getSpells { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noDate, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(actualData)
    }

    func testGetSpellsFailureDecodingError() {
        mockNetworking.shouldReturnError = true
        var actualData: [Spell]?
        var receivedError: NetworkError?

        mockNetworking.getSpells { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }

    func testFetchImageSuccess() {
        let expectedData = createImageData()
        mockNetworking.mockedImageData = expectedData

        guard let url = URL(string: "test") else { return }
        var actualData: Data?
        var receivedError: NetworkError?

        mockNetworking.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNil(receivedError)
        XCTAssertEqual(actualData, expectedData, "The actual result \(String(describing: actualData)) differs from the expected one \(String(describing: expectedData))")
    }

    func testFetchImageFailureNoDate() {
        var actualData: Data?
        var receivedError: NetworkError?

        guard let url = URL(string: "test") else { return }

        mockNetworking.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noDate, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(actualData)
    }

    func testFetchImageFailureDecodingError() {
        mockNetworking.shouldReturnError = true
        var actualData: Data?
        var receivedError: NetworkError?

        guard let url = URL(string: "test") else { return }

        mockNetworking.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error
            }
        }

        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }

    func createArray<T: Decodable>(fromResource resource: String) -> [T]? {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode([T].self, from: jsonData)
            return items
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
    }

    func createImageData() -> Data? {
        guard let url = Bundle(for: type(of: self)).url(forResource: "harry", withExtension: "png"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        return jsonData
    }
}
