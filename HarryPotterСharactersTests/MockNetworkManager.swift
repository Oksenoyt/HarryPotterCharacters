//
//  MockURLSession.swift
//  HarryPotterСharactersTests
//
//  Created by Oksenoyt on 16.10.2023.
//

import Foundation
@testable import HarryPotterСharacters

class MockNetworkManager: NetworkingManagerProtocol {
    var shouldReturnError = false
    var mockedCharacters: [Character]?
    var mockedSpells: [Spell]?
    var mockedImageData: Data?

    func getCharacters(completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.decodingError))
        } else if let characters = mockedCharacters, !characters.isEmpty {
            completion(.success(characters))
        } else {
            completion(.failure(.noData))
        }
    }

    func getSpells(completion: @escaping (Result<[Spell], NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.decodingError))
        } else if let spells = mockedSpells, !spells.isEmpty {
            completion(.success(spells))
        } else {
            completion(.failure(.noData))
        }
    }

    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.decodingError))
        } else if let imageData = mockedImageData, !imageData.isEmpty {
            completion(.success(imageData))
        } else {
            completion(.failure(.noData))
        }
    }
}
