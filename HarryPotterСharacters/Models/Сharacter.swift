//
//  File.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//
struct Character: Decodable {
    let name: String
    let house: String
    let wand: Wand
    let image: String
    let actor: String
}

struct Wand: Decodable {
    let wood: String
    let core: String
}
