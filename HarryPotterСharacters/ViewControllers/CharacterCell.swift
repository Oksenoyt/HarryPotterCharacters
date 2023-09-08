//
//  CollectionViewCell.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

final class CharacterCell: UICollectionViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameCharacterLabel: UILabel!

    private var imageURL: URL? {
        didSet {
            characterImageView.image =  nil
            updateImage()
        }
    }

    func imageCongigure(with character: Character) {
        nameCharacterLabel.text = character.name
        imageURL = URL(string: character.image)
        layer.cornerRadius = 10
    }

    private func updateImage() {
        guard let url = imageURL else { return }

        getImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                if url == self?.imageURL {
                    self?.characterImageView.image = image

                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {

        if let cahcedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            print("Image from cache: ", url.lastPathComponent)
            completion(.success(cahcedImage))
            return
        }

        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else {
                    print(NetworkError.decodingError)
                    return
                }

                ImageCacheManager.shared.setObject(uiImage, forKey: url.lastPathComponent as NSString)
                print("Image from network: ", url.lastPathComponent)
                completion(.success(uiImage))

            case .failure(let error):
                print(error)
            }
        }
    }


}
