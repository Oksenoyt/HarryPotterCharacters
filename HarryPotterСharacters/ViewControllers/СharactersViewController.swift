//
//  CollectionViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

enum Link: String {
    case character = "https://hp-api.onrender.com/api/characters"
    case spells = "https://hp-api.onrender.com/api/spells"
}


final class CollectionViewController: UICollectionViewController {

    var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        setupRefreshControl()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailsViewController else { return }
        guard let cell = sender as? UICollectionViewCell else { return }
        guard let inpexPatx = collectionView.indexPath(for: cell) else { return }
        detailsVC.character = characters[inpexPatx.row]
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
        cell.сongigure(with: character)
        
        return cell
    }

    // MARK: - Private function
    private func fetchData() {
        NetworkManager.shared.fetch([Character].self, from: Link.character.rawValue) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let charactersList):
                characters = charactersList.filter { $0.image != "" }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        fetchData()
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
