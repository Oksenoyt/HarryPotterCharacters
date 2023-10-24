//
//  NetworkingManagerProtocol.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 16.10.2023.
//

import Foundation

protocol NetworkingManagerProtocol: AnyObject {
    func getCharacters(completion: @escaping(Result<[Character], NetworkError>) ->  Void)
    func getSpells(completion: @escaping(Result<[Spell], NetworkError>) ->  Void)
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) ->  Void)
}
