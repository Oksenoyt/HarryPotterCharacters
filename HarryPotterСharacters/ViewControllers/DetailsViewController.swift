//
//  ViewController.swift
//  HarryPotterСharacters
//
//  Created by Elenka on 09.08.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: character.image) 
        nameLabel.text = character.name
        descriptionLabel.text = "wizard: \(character.wizard) \n house: \(character.house) \n "

    }
}
