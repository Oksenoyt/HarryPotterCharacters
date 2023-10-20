//
//  File.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//

import Foundation

struct Character: Codable, Equatable {
    let name: String
    let house: String
    let wand: Wand
    let image: String
    let actor: String

    static func ==(lhs: Character, rhs: Character) -> Bool {
        return lhs.name == rhs.name &&
               lhs.house == rhs.house &&
               lhs.wand == rhs.wand &&
               lhs.image == rhs.image &&
               lhs.actor == rhs.actor
    }
}
