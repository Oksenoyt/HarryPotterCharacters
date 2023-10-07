//
//  CollectionViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

final class CollectionViewController: UICollectionViewController {

    private var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        setupRefreshControl()
    }

    @IBAction func SpellsButtonAction(_ sender: Any) {
        let spellsVC = SpellsTableViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: spellsVC)
        present(navigationController, animated: true, completion: nil)
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
        cell.congigure(with: character)

        return cell
    }

    // MARK: - Private function
    private func fetchData() {
        NetworkManager.shared.getCharacters { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let characterList):
                characters = characterList
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        refreshControl.tintColor = .lightGray
        refreshControl.attributedTitle =
        NSAttributedString(
            string: "Pull to refresh",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailsViewController.instantiate()
        detailVC.character = characters[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: UIScreen.main.bounds.width/2 - 5,
            height: UIScreen.main.bounds.width/1.5
        )
    }
}
