//
//  AppFlowController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

final class AppFlowController: UIViewController {

    let store: ProductStore

    init(store: ProductStore) {
        self.store = store

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var productListViewController = ProductListViewController()

    private lazy var rootNavigationController: UINavigationController = {
        let controller = UINavigationController(rootViewController: productListViewController)

        controller.navigationBar.prefersLargeTitles = true

        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        installRootNavigationController()
        installProductListSupport()
    }

    private func installRootNavigationController() {
        addChild(rootNavigationController)
        rootNavigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootNavigationController.view.frame = view.bounds
        view.addSubview(rootNavigationController.view)
        rootNavigationController.didMove(toParent: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadProducts()
    }

    private func loadProducts() {
        productListViewController.showLoadingIndicatorIfNeeded()

        store.fetchAll { [weak self] result in
            switch result {
            case .error(let error):
                fatalError("Demo mode should never return an error, but returned error: \(error.localizedDescription)")
            case .success(let products):
                self?.productListViewController.viewModels = products.map(ProductViewModel.init)
            }
        }
    }

    // MARK: - Product listing

    private func installProductListSupport() {
        productListViewController.delegate = self

        hideNavigationBarBackground(animated: false)

        productListViewController.scrollableContentDidStartIntersectingSafeArea = { [weak self] in
            self?.showNavigationBarBackground()
        }
        productListViewController.scrollableContentDidStopIntersectingSafeArea = { [weak self] in
            self?.hideNavigationBarBackground()
        }
    }

    private let animationDuration: Double = 0.3

    private func hideNavigationBarBackground(animated: Bool = true) {
        let duration = animated ? animationDuration : 0

        UIView.animate(withDuration: duration) {
            self.rootNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.rootNavigationController.navigationBar.barTintColor = .clear
        }
    }

    private func showNavigationBarBackground(animated: Bool = true) {
        let duration = animated ? animationDuration : 0

        UIView.animate(withDuration: duration) {
            self.rootNavigationController.navigationBar.setBackgroundImage(nil, for: .default)
            self.rootNavigationController.navigationBar.barTintColor = .white
        }
    }

    // MARK: - Detail presentation

    func pushDetailForProduct(with identifier: String) {
        productListViewController.showLoadingIndicatorIfNeeded()

        store.fetch(with: identifier) { [weak self] result in
            switch result {
            case .success(let product):
                self?.pushDetail(for: product)
            case .error(let error):
                NSLog("Invalid product identifier: \(identifier). \(error.localizedDescription)")
            }
        }
    }

    func pushDetail(for product: Product) {
        let viewModel = ProductViewModel(product: product)
        pushDetail(for: viewModel)
    }

    func pushDetail(for viewModel: ProductViewModel) {
        let detailController = ProductDetailsViewController(viewModel: viewModel)

        detailController.delegate = self

        rootNavigationController.pushViewController(detailController, animated: true)
    }

    // MARK: - Purchase flow

    private var currentPurchaseFlow: PurchaseFlowController?

    func purchase(_ products: [Product]) {
        let flow = PurchaseFlowController(from: self, with: products)

        flow.delegate = self

        flow.start()

        currentPurchaseFlow = flow
    }

}

// MARK: - ProductListViewControllerDelegate

extension AppFlowController: ProductListViewControllerDelegate {

    func productListViewController(_ controller: ProductListViewController, didSelectViewModel viewModel: ProductViewModel) {
            pushDetail(for: viewModel)
    }

}

// MARK: - ProductDetailsViewControllerDelegate

extension AppFlowController: ProductDetailsViewControllerDelegate {

    func productDetailsViewController(_ controller: ProductDetailsViewController, didSelectPurchase product: Product) {
        purchase([product])
    }

}

// MARK: - PurchaseFlowControllerDelegate

extension AppFlowController: PurchaseFlowControllerDelegate {

    func purchaseFlowControllerDidPresentSuccessScreen(_ controller: PurchaseFlowController) {
        // Go back to the home screen once the transition to the success screen is completed
        rootNavigationController.popToRootViewController(animated: false)
    }

}
