//
//  AccountOptionsViewController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit
import Combine

struct AccountMenuOption: Hashable {
    let title: String
    let action: (UIView) -> Void

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    static func ==(lhs: AccountMenuOption, rhs: AccountMenuOption) -> Bool {
        lhs.title == rhs.title
    }
}

final class AccountOptionsViewController: UITableViewController {

    let viewModel: AccountViewModel
    var options: [AccountMenuOption] {
        didSet {
            guard options != oldValue else { return }

            tableView.reloadSections(IndexSet([0]), with: .automatic)
        }
    }

    init(viewModel: AccountViewModel, options: [AccountMenuOption]) {
        self.viewModel = viewModel
        self.options = options

        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { options.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = options[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        options[indexPath.row].action(cell)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}
