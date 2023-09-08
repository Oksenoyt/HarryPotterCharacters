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

        getImage(from: character.image)
    }

    private func getImage(from url: String) {
        guard let imageURL = URL(string: character.image) else { return }

        if let cahcedImage = ImageCacheManager.shared.object(forKey: imageURL.lastPathComponent as NSString) {
            imageView.image = cahcedImage
            return
        }

        NetworkManager.shared.fetchImage(from: imageURL) { [weak self] result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else {
                    print(NetworkError.decodingError)
                    return
                }

                ImageCacheManager.shared.setObject(uiImage, forKey: imageURL.lastPathComponent as NSString)
                self?.imageView.image = uiImage

            case .failure(let error):
                print(error)
            }
        }
    }
}
