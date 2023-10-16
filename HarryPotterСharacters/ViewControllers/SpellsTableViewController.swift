//
//  SpellsTableViewController.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 02.09.2023.
//

import UIKit

final class SpellsTableViewController: UITableViewController, Storyboarded {
    enum Section: Int {
        case favorites
        case original
    }


    @IBOutlet weak var searchBar: UISearchBar!

    private let storageManager: StorageManagerProtocol = StorageManager()
    private let netrowkManager: NetworkingManagerProtocol = NetworkManager()
    private var spells: [Spell] = []
    private var filteredSpells: [Spell] = []
    private var nonFavoriteSpells: [Spell] = []
    private var favoritesSpell: [Spell] = []

    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return true }
        return text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchSpell()
    }

    private func fetchSpell() {
        netrowkManager.getSpells { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let spells):
                self.spells = spells
                setFavorites()
                filterSpells()
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.original.rawValue + 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.favorites.rawValue {
            return favoritesSpell.isEmpty ? nil : String(localized: "Favorites spells")
        } else {
            return String(localized: "Spells")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == Section.favorites.rawValue ? favoritesSpell.count : nonFavoriteSpells.count
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

        if indexPath.section == Section.favorites.rawValue {
            cell.configure(for: favoritesSpell[indexPath.row])
        } else {
            cell.configure(for: nonFavoriteSpells[indexPath.row])
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
        configureHeader(view: header)
    }

    // MARK: - Private function
    private func configureHeader(view: UITableViewHeaderFooterView) {
        view.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 22)
        view.textLabel?.numberOfLines = 0
        view.textLabel?.lineBreakMode = .byWordWrapping
        view.textLabel?.textColor = UIColor.black
        view.sizeToFit()
    }

    private func setFavorites() {
        let favorites = storageManager.fetch()
        for index in 0..<spells.count {
            let isFavorites = favorites.contains { $0 == spells[index].id }
            spells[index].isFavorites = isFavorites
        }
    }

    private func refreshSpells(_ spell: Spell) {
        if let index = spells.firstIndex(where: { $0.name == spell.name }) {
            spells[index] = spell
        } else {
            print("element not found")
        }
    }

    private func filterSpells() {
        nonFavoriteSpells = searchBarIsEmpty
        ? spells.filter { $0.isFavorites == false }
        : filteredSpells.filter { $0.isFavorites == false }
        favoritesSpell = spells.filter { $0.isFavorites == true }
    }
}

// MARK: - UISearchBarDelegate
extension SpellsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSpells.removeAll()
        filterSpells()
        guard searchText != "" else {
            tableView.reloadData()
            return }
        filterContentForSearchText(searchText)
    }

    private func filterContentForSearchText(_ searchText: String) {
        filteredSpells = spells.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        filterSpells()
        tableView.reloadData()
    }
}

// MARK: - SpellsTableViewDelegate
extension SpellsTableViewController: SpellsTableViewDelegate {
    func refreshFavorites(from spell: Spell) {
        spell.isFavorites
        ? storageManager.save(spell: spell.id)
        : storageManager.remove(spell: spell.id)

        spell.isFavorites
        ? movingToFavoritesSpells(spell)
        : movingToAllSpells(spell)

        refreshSpells(spell)
    }

    private func movingToAllSpells(_ spell: Spell) {
        guard let index = favoritesSpell.firstIndex(where: { $0.name == spell.name }) else {
            return
        }
        let indexPathFrom = IndexPath(row: index, section: Section.favorites.rawValue)
        let indexPathTo = IndexPath(row: nonFavoriteSpells.count, section: Section.original.rawValue)

        favoritesSpell.remove(at: index)
        nonFavoriteSpells.append(spell)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPathFrom], with: .automatic)
            tableView.insertRows(at: [indexPathTo], with: .automatic)
        }, completion: nil)
    }

    private func movingToFavoritesSpells(_ spell: Spell) {
        guard let index = nonFavoriteSpells.firstIndex(where: { $0.name == spell.name }) else {
            return
        }
        let indexPathFrom = IndexPath(row: index, section: Section.original.rawValue)
        let indexPathTo = IndexPath(row: favoritesSpell.count, section: Section.favorites.rawValue)

        nonFavoriteSpells.remove(at: index)
        favoritesSpell.append(spell)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPathFrom], with: .automatic)
            tableView.insertRows(at: [indexPathTo], with: .automatic)
        }, completion: nil)
    }
}
