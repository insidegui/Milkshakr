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
        AccountHomeViewController(viewModel: viewModel)
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

}
