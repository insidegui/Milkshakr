//
//  AppClipFlowController.swift
//  Clip
//
//  Created by Guilherme Rambo on 21/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

final class AppClipFlowController: UIViewController {

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

    private(set) lazy var productListingFlow: ProductListingFlowController = {
        ProductListingFlowController(productStore: productStore, accountStore: accountStore)
    }()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .background

        install(productListingFlow)
    }

    func handle(_ activity: NSUserActivity) {
        productListingFlow.pushDetail(from: activity)
    }

}
