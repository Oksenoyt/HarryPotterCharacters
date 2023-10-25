//
//  ViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//

import UIKit

final class DetailsViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private var activityIndicator: UIActivityIndicatorView?
    private let networkManager: NetworkingManagerProtocol = NetworkManager()
    private var retryFetchImage = 0

    var character: Character!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: character)
    }

    // MARK: - Private function
    private func configure(with character: Character) {
        nameLabel.text = character.name
        descriptionLabel.text = String(localized: "\nhouse: \(character.house) \nwand: \(character.wand.wood) \nactor: \(character.actor )")

        activityIndicator = ActivityIndicator().showSpinner(in: imageView)
        layoutActivityIndicator()

        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        getImage(from: character.image)
    }

    private func getImage(from url: String) {
        retryFetchImage += 1
        guard let imageURL = URL(string: url) else { return }

        if let cahcedImage = ImageCacheManager.shared.object(forKey: imageURL.lastPathComponent as NSString) {
            imageView.image = cahcedImage

            activityIndicator?.stopAnimating()
            return
        }

        networkManager.fetchImage(from: imageURL) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else {
                    showAlert()
                    return
                }

                ImageCacheManager.shared.setObject(uiImage, forKey: imageURL.lastPathComponent as NSString)
                imageView.image = uiImage
                activityIndicator?.stopAnimating()
            case .failure(let error):
                showAlert(error: error.localizedDescription)
            }
        }
    }

    private func showAlert(error: String? = nil) {
        let buttonAction: (() -> Void)? = retryFetchImage < 3
        ? { [weak self] in
            guard let character = self?.character else { return }
            self?.getImage(from: character.image)
        }
        : nil

        let alert = AlertController.simpleAlert(
            retry: retryFetchImage, 
            error: error
        ) {
            buttonAction?()
        }
        present(alert, animated: true)
    }

    private func layoutActivityIndicator(){
        guard let activityIndicator = activityIndicator else { return }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
