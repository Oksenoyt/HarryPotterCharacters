//
//  CollectionViewCell.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameCharacterLabel: UILabel!
    
    func imageCongigure(with character: Character) {
        nameCharacterLabel.text = character.name
        layer.cornerRadius = 10

        NetworkManager.shared.fetchImage(from: character.image) { [weak self] result in
            switch result {
            case .success(let imageCharacter):
                self?.characterImageView.image = UIImage(data: imageCharacter)
            case .failure(let error):
                print(error)
            }
        }
    }
}
