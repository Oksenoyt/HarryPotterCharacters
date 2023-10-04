//
//  SpellsTableViewController.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 02.09.2023.
//

import UIKit

final class SpellsTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    private var spells: [Spell] = []
    private var filteredSpells: [Spell] = []
    private var nonFavoriteSpells: [Spell] {
        searchBarIsEmpty
        ? spells.filter { $0.favorites == false }
        : filteredSpells
    }

    private var favoritesSpell: [Spell] {
        spells.filter { $0.favorites == true }
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
        favoritesSpell.count == 0 ? 1 : 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if favoritesSpell.count > 0 {
            return section == 0 ? "Favorites spells" : "Spells"
        } else {
            return "Spells"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesSpell.count > 0 && section == 0 {
            return favoritesSpell.count
        } else {
            return nonFavoriteSpells.count
        }
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

        if favoritesSpell.count > 0 {
            if indexPath.section == 0 {
                let favoriteSpell = favoritesSpell[indexPath.row]
                cell.configure(for: favoriteSpell)
            } else {
                let spell = nonFavoriteSpells[indexPath.row]
                cell.configure(for: spell)
            }
        } else {
            let spell = nonFavoriteSpells[indexPath.row]
            cell.configure(for: spell)
        }

        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView

        header?.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 22)
        header?.textLabel?.numberOfLines = 0
        header?.textLabel?.lineBreakMode = .byWordWrapping
        header?.textLabel?.textColor = UIColor.black
    }


    // MARK: - Private function
    private func fetchSpell() {
        NetworkManager.shared.fetch([Spell].self, from: Link.spells.rawValue) { [weak self] result in
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
            spells[index].favorites = isFavorites
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
