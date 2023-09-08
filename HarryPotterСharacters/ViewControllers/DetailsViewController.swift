//
//  ViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(with: character)
    }

    func configure(with character: Character) {
        nameLabel.text = character.name
        descriptionLabel.text = "\nhouse: \(character.house) \nwand: \(character.wand.wood) \nactor: \(character.actor )"

        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill

//        NetworkManager.shared.fetchImage(from: character.image) { [weak self] result in
//            switch result {
//            case .success(let imageCharacter):
//                self?.imageView.image = UIImage(data: imageCharacter)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
