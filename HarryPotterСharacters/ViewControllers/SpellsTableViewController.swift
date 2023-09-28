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
    private var currentSpells: [Spell] {
        searchBarIsEmpty ? spells : filteredSpells
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
        currentSpells.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        currentSpells[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpellCell", for: indexPath)
        let spell = currentSpells[indexPath.section]
        var content = cell.defaultContentConfiguration()
        content.text = spell.description
        cell.contentConfiguration = content
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView

        header?.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        header?.textLabel?.numberOfLines = 0
        header?.textLabel?.lineBreakMode = .byWordWrapping
    }


    // MARK: - Private function
    private func fetchSpell() {
        NetworkManager.shared.fetch([Spell].self, from: Link.spells.rawValue) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let spells):
                self.spells = spells
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
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
