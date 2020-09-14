//
//  AccountFlowController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

final class AccountFlowController: UIViewController {

    let store: AccountStore

    init(store: AccountStore) {
        self.store = store

        super.init(nibName: nil, bundle: nil)

        tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.fill"), selectedImage: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .background
    }

}
