//
//  CollectionViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 11.08.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var characters: [Character] = []
    
    private let link = "http://hp-api.herokuapp.com/api/characters"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchData()
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    //   MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailsViewController else { return }
        guard let cell = sender as? UICollectionViewCell else { return } // такой способ передачи данных норма? или лучше как то иначе?
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
        cell.nameCharacterLabel.text = character.name
        cell.imageCongigure(with: character)
        
        return cell
    }
    
    private func fetchData() {
        NetworkManager.shared.fetch([Character].self, from: link) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters.filter { $0.image != "" }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width/2 - 5, height: UIScreen.main.bounds.width/1.5  )
    }
}
