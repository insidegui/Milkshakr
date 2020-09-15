//
//  AppFlowController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

final class AppFlowController: UIViewController {

    let accountStore: AccountStore
    let productStore: ProductStore

    init(accountStore: AccountStore, productStore: ProductStore) {
        self.accountStore = accountStore
        self.productStore = productStore

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private(set) lazy var accountFlow: AccountFlowController = {
        AccountFlowController(store: accountStore)
    }()

    private(set) lazy var productListingFlow: ProductListingFlowController = {
        ProductListingFlowController(productStore: productStore, accountStore: accountStore)
    }()

    private lazy var tabController: UITabBarController = {
        let c = UITabBarController(nibName: nil, bundle: nil)

        c.addChild(productListingFlow)
        c.addChild(accountFlow)

        return c
    }()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .background

        install(tabController)
    }

    func goHome() {
        tabController.selectedIndex = 0
        productListingFlow.goHome()
    }

    func pushProductDetail(from userActivity: NSUserActivity, purchase: Bool = false) {
        productListingFlow.pushDetail(from: userActivity, purchase: purchase)
    }

}
