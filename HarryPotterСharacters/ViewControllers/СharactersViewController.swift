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
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    private func fetchData() {
        NetworkManager.shared.fetch([Character].self, from: link) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
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
        CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.width/1.9  )
    }
}
