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

    private var currentSpell: Spell?
    var delegate: SpellsTableViewDelegate?

    @IBAction func favoritesButtonAction(_ sender: Any) {
        guard var spell = currentSpell else { return }
        spell.isFavorites.toggle()
        delegate?.refreshFavorites(from: spell)

        currentSpell?.isFavorites.toggle()
        setFavoritesButtonImage()
    }

    func configure(for spell: Spell) {
        currentSpell = spell
        titleLabel.text = spell.name
        descriptionLabel.text = spell.description
        setFavoritesButtonImage()
    }

    private func setFavoritesButtonImage() {
        guard let spell = currentSpell else { return }
        spell.isFavorites
        ? favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        : favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
}
