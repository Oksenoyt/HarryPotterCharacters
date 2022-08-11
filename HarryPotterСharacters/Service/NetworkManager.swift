//
//  NetworkManager.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noDate
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private let link = "http://hp-api.herokuapp.com/api/characters"
    
    private init() {}
    
    func fetchCharacters(completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noDate))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let characters = try JSONDecoder().decode([Character].self, from: data)
                let rundomElement = Int.random(in: 0..<characters.count)
                print(characters[rundomElement])
                completion(.success(characters))
            } catch let error {
                completion(.failure(.decodingError))
                print(error)
            }
        }.resume()
    }
    
    func fetchImage(from url: String, completion: @escaping(Result<Data, NetworkError>) ->  Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageDate = try? Data(contentsOf: url) else {
                completion(.failure(.noDate))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageDate))
            }
        }
    }
}
