//
//  AccountFlowController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit
import SwiftUI

final class AccountFlowController: UIViewController {

    let viewModel: AccountViewModel

    init(store: AccountStore) {
        self.viewModel = AccountViewModel(store: store)

        super.init(nibName: nil, bundle: nil)

        tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.fill"), selectedImage: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private lazy var homeController: AccountHomeViewController = {
        let c = AccountHomeViewController(viewModel: viewModel)

        c.showOrderHistoryHandler = { [weak self] in
            self?.showOrderHistory()
        }

        c.signOutHandler = { [weak self] in
            self?.viewModel.signOut()
        }

        return c
    }()

    private lazy var ownedNavigationController: UINavigationController = {
        let c = UINavigationController(rootViewController: homeController)

        c.navigationBar.prefersLargeTitles = true

        return c
    }()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .background

        install(ownedNavigationController)
    }

    func showOrderHistory() {
        let controller = UIHostingController(rootView: OrderHistoryView().environmentObject(viewModel.store))
        controller.title = "Order History"
        controller.navigationItem.largeTitleDisplayMode = .never
        ownedNavigationController.pushViewController(controller, animated: true)
    }

}
