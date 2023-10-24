//
//  NetworkManager.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import Foundation

enum Link: String {
    case character = "https://hp-api.onrender.com/api/characters"
    case spells = "https://hp-api.onrender.com/api/spells"
}

enum NetworkError: Error {
    case invalidURL
    case noDate
    case decodingError
}

class NetworkManager: NetworkingManagerProtocol {

    func getCharacters(completion: @escaping(Result<[Character], NetworkError>) ->  Void) {
        fetch([Character].self, from: Link.character.rawValue) { result in

            switch result {
            case .success(let charactersList):
                let characters = charactersList.filter { !$0.image.isEmpty }
                completion(.success(characters))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getSpells(completion: @escaping(Result<[Spell], NetworkError>) ->  Void) {
        fetch([SpellForParsingAPI].self, from: Link.spells.rawValue) { result in
            switch result {
            case .success(let spellsTemp):
                let spells = spellsTemp.map { spell in
                    Spell(
                        id: "\(spell.name)" + "\(spell.description.prefix(3))",
                        name: spell.name,
                        description: spell.description,
                        isFavorites: false
                    )
                }
                completion(.success(spells))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) ->  Void) {
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

    // MARK: - Private function
    private func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) ->  Void) {
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
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
