//
//  StorageManagerProtocol.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 16.10.2023.
//

import Foundation

protocol StorageManagerProtocol: AnyObject {
    func save(spell: String)
    func fetch() -> [String]
    func remove(spell: String)
}
