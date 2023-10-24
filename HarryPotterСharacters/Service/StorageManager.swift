//
//  StorageManager.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 03.10.2023.
//

import Foundation

final class StorageManager: StorageManagerProtocol {
    private var defaults: UserDefaults
    private let favoritesKey = "favoritesSpells"
    private(set) var favoritesSpells: [String] = []

    init (userDefaults: UserDefaults = UserDefaults.standard) {
        defaults = userDefaults
    }

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
        favoritesSpells = favoritesSpells.filter { $0 != spell }
        defaults.set(favoritesSpells, forKey: favoritesKey)
    }
}
