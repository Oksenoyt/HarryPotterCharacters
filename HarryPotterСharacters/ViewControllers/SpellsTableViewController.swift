//
//  SpellsTableViewController.swift
//  HarryPotterСharacters
//
//  Created by Oksenoyt on 02.09.2023.
//

import UIKit

final class SpellsTableViewController: UITableViewController {
    private var spells: [Spell] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSpell()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        spells.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        spells[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpellCell", for: indexPath)
        let spell = spells[indexPath.section]
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
    }


    // MARK: - Private function
    private func fetchSpell() {
        NetworkManager.shared.fetch([Spell].self, from: Link.spells.rawValue) { [weak self] result in
            switch result {
            case .success(let spells):
                self?.spells = spells
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}
