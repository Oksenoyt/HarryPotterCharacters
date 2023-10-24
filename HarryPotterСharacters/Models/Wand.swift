//
//  Wand.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 04.10.2023.
//

import Foundation

struct Wand: Decodable, Equatable{
    let wood: String
    let core: String

    static func ==(lhs: Wand, rhs: Wand) -> Bool {
        return lhs.wood == rhs.wood &&
               lhs.core == rhs.core
    }
}
