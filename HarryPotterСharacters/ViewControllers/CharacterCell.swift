//
//  CollectionViewCell.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

final class CharacterCell: UICollectionViewCell {

    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameCharacterLabel: UILabel!

    private let networkManager: NetworkingManagerProtocol = NetworkManager()
    private var activityIndicator: UIActivityIndicatorView?

    private var imageURL: URL? {
        didSet {
            characterImageView.image =  nil
            updateImage()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        activityIndicator = ActivityIndicator().showSpinner(in: characterImageView)
        layoutActivityIndicator()
    }


    func congigure(with character: Character) {
        nameCharacterLabel.text = character.name
        imageURL = URL(string: character.image)
        layer.cornerRadius = 10
    }

    // MARK: - Private function
    private func updateImage() {
        guard let url = imageURL else { return }

        getImage(from: url) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let image):
                if url == imageURL {
                    characterImageView.image = image
                    activityIndicator?.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {

        if let cahcedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            completion(.success(cahcedImage))
            return
        }

        networkManager.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else {
                    print(NetworkError.decodingError)
                    return
                }

                ImageCacheManager.shared.setObject(uiImage, forKey: url.lastPathComponent as NSString)
                completion(.success(uiImage))

            case .failure(let error):
                print(error)
            }
        }
    }

    private func layoutActivityIndicator(){
        guard let activityIndicator = activityIndicator else { return }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: characterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor)
        ])
    }
}
