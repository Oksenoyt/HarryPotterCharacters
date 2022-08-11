//
//  CollectionViewCell.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    
    func congigure(with character: Character) {
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
