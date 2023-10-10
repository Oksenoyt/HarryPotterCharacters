//
//  SpellsTableViewController.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 02.09.2023.
//

import UIKit

final class SpellsTableViewController: UITableViewController, Storyboarded {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private let storageManager = StorageManager.shared
    private var spells: [Spell] = []
    private var filteredSpells: [Spell] = []
    private var nonFavoriteSpells: [Spell] {
        searchBarIsEmpty
        ? spells.filter { $0.isFavorites == false }
        : filteredSpells
    }

    private var favoritesSpell: [Spell] {
        spells.filter { $0.isFavorites == true }
    }

    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return true }
        return text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchSpell()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return favoritesSpell.isEmpty ? nil : "Favorites spells"
        } else {
            return "Spells"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? favoritesSpell.count : nonFavoriteSpells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "spellCell",
                for: indexPath
            ) as? SpellsTableViewCell
        else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            let favoriteSpell = favoritesSpell[indexPath.row]
            cell.configure(for: favoriteSpell)
        } else {
            let spell = nonFavoriteSpells[indexPath.row]
            cell.configure(for: spell)
        }

        cell.delegate = self
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 22)
        header.textLabel?.numberOfLines = 0
        header.textLabel?.lineBreakMode = .byWordWrapping
        header.textLabel?.textColor = UIColor.black
        header.sizeToFit()
    }

    // MARK: - Private function
    private func fetchSpell() {
        NetworkManager.shared.getSpells { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let spells):
                self.spells = spells
                setFavorites()
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setFavorites() {
        let favorites = StorageManager.shared.fetch()

        for index in 0..<spells.count {
            let isFavorites = favorites.contains { $0.contains(spells[index].name) }
            spells[index].isFavorites = isFavorites
        }
    }
}

// MARK: - UISearchBarDelegate
extension SpellsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSpells.removeAll()

        guard searchText != "" else {
            tableView.reloadData()
            return }
        filterContentForSearchText(searchText)
    }

    private func filterContentForSearchText(_ searchText: String) {
        filteredSpells = spells.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        tableView.reloadData()
    }
}

// MARK: - SpellsTableViewDelegate
extension SpellsTableViewController: SpellsTableViewDelegate {
    func refreshFavorites(from spell: Spell) {
        spell.isFavorites
        ? storageManager.remove(spell: spell.name)
        : storageManager.save(spell: spell.name)

        spell.isFavorites
        ? movingToFavoritesSpells(spell)
        : movingToAllSpells(spell)
    }

    private func movingToAllSpells(_ spell: Spell) {
        guard let index = favoritesSpell.firstIndex(where: { $0.name == spell.name }) else {
            return
        }
        let indexPathFrom = IndexPath(row: index, section: 0)
        let indexPathTo = IndexPath(row: nonFavoriteSpells.count, section: 1)

        tableView.beginUpdates()
        refrashSpells(spell)
        tableView.deleteRows(at: [indexPathFrom], with: .fade)
        tableView.insertRows(at: [indexPathTo], with: .fade)
        tableView.endUpdates()
    }

    private func movingToFavoritesSpells(_ spell: Spell) {
        guard let index = nonFavoriteSpells.firstIndex(where: { $0.name == spell.name }) else {
            return
        }
        let indexPathFrom = IndexPath(row: index, section: 1)
        let indexPathTo = IndexPath(row: favoritesSpell.count, section: 0)

        tableView.beginUpdates()
        refrashSpells(spell)
        tableView.deleteRows(at: [indexPathFrom], with: .fade)
        tableView.insertRows(at: [indexPathTo], with: .fade)
        tableView.endUpdates()
    }

    private func refrashSpells(_ spell: Spell) {
        if let index = filteredSpells.firstIndex(where: { $0.name == spell.name }) {
            filteredSpells.remove(at: index)
        }

        if let index = spells.firstIndex(where: { $0.name == spell.name }) {
            spells[index] = spell
        } else {
            print("element not found")
        }
    }
}
