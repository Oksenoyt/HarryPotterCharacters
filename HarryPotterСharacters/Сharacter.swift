//
//  File.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//
struct Character: Decodable {
    let name: String
    let wizard: Bool
    let house: String
    let wand: Wand
    let hogwartsStudent: Bool
    let image: String
    let actor: String
}

struct Wand: Decodable {
    let wood: String
    let core: String
//    let length: Int? не смогла подобрать тип :(
}
