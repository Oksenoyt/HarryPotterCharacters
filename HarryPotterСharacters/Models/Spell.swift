//
//  Spell.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 02.09.2023.
//

import Foundation

struct Spell: Decodable, Equatable {
    let id: String
    let name: String
    let description: String
    var isFavorites: Bool

    static func ==(lhs: Spell, rhs: Spell) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.isFavorites == rhs.isFavorites
    }
}
