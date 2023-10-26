//
//  CollectionViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

final class СharactersViewController: UICollectionViewController {

    private var characters: [Character] = []
    private var activityIndicator: UIActivityIndicatorView?
    private let networkManager: NetworkingManagerProtocol = NetworkManager()
    private var retryFetchImage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        setupRefreshControl()
        activityIndicator = ActivityIndicator().showSpinner(in: view)
    }

    private func fetchData() {
        retryFetchImage += 1
        networkManager.getCharacters { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let characterList):
                characters = characterList
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                    self.activityIndicator?.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(error: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(error: String? = nil) {
        let buttonAction: (() -> Void)? = retryFetchImage < 3
        ? { [weak self] in
            self?.fetchData()
        }
        : nil

        let alert = AlertController.simpleAlert(
            retry: retryFetchImage,
            error: error
        ) { buttonAction?() }
        
        present(alert, animated: true)
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        refreshControl.tintColor = .lightGray
        refreshControl.attributedTitle =
        NSAttributedString(
            string: String(localized: "Pull to refresh"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }

    @IBAction func SpellsButtonAction(_ sender: Any) {
        let spellsVC = SpellsTableViewController.instantiate()
        present(spellsVC, animated: true, completion: nil)
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        fetchData()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "characterCell",
                for: indexPath
            ) as? CharacterCell
        else {
            return UICollectionViewCell()
        }

        let character = characters[indexPath.row]
        cell.delegate = self
        cell.congigure(with: character)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailsViewController.instantiate()
        detailVC.character = characters[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension СharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: UIScreen.main.bounds.width/2 - 5,
            height: UIScreen.main.bounds.width/1.5
        )
    }
}

// MARK: СharactersViewDelegate
extension СharactersViewController: СharactersViewDelegate {
    func didRequestToShowAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}

