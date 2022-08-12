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
    
    private init() {}
    
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
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) ->  Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noDate))
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                print(type)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
