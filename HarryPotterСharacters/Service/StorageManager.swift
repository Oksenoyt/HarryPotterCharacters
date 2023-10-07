//
//  StorageManager.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 03.10.2023.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private let defaults = UserDefaults.standard
    private let favoritesKey = "favoritesSpells"
    private var favoritesSpells: [String] = []

    private init () {}

    func save(spell: String) {
        favoritesSpells.append(spell)
        defaults.set(favoritesSpells, forKey: favoritesKey)
    }

    func fetch() -> [String] {
        if let favorites = defaults.value(forKey: favoritesKey) as? [String] {
            favoritesSpells = favorites
            return favorites
        }
        return []
    }

    func remove(spell: String) {
        favoritesSpells = favoritesSpells.filter( { !$0.contains(spell)} )
        defaults.set(favoritesSpells, forKey: favoritesKey)
    }

    func removeAll() {
        defaults.removeObject(forKey: favoritesKey)
    }

}
