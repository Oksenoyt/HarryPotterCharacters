//
//  SpellsTableViewCell.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 03.10.2023.
//

import UIKit

final class SpellsTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private let storageManager = StorageManager.shared
    private var spellIsFavorites = false
    private var currentSpell: Spell?
    var delegate: SpellsTableViewDelegate?

    @IBAction func favoritesButtonAction(_ sender: Any) {
        guard var spell = currentSpell else { return }
        spell.favorites?.toggle()

        spellIsFavorites
        ? storageManager.remove(spell: spell.name)
        : storageManager.save(spell: spell.name)

        delegate?.refreshFavorites(from: spell)

        spellIsFavorites.toggle()
        setFavoritesButtonImage()
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
