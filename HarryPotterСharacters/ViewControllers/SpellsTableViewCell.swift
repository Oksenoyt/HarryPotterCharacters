//
//  SpellsTableViewCell.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 03.10.2023.
//

import UIKit

class SpellsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    private let storageManager = StorageManager.shared
    private var spellIsFavorites = false
    private var currentSpell: Spell?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func favoritesButtonAction(_ sender: Any) {
        guard let spell = currentSpell else { return }

        spellIsFavorites
        ? storageManager.remove(spell: spell.name)
        : storageManager.save(spell: spell.name)

        spellIsFavorites.toggle()
        setFavoritesButtonImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for spell: Spell) {
        currentSpell = spell
        titleLabel.text = spell.name
        descriptionLabel.text = spell.description
        spellIsFavorites = spell.favorites ?? false
        setFavoritesButtonImage()
    }

    private func setFavoritesButtonImage() {
        spellIsFavorites
        ? favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        : favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
}
