//
//  ProductListViewController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

protocol ProductListViewControllerDelegate: class {
    func productListViewController(_ controller: ProductListViewController, didSelectViewModel viewModel: ProductViewModel)
}

final class ProductListViewController: UIViewController {

    weak var delegate: ProductListViewControllerDelegate?

    private struct Constants {
        static let productCellIdentifier = "productCell"
    }

    var viewModels: [ProductViewModel] = [] {
        didSet {
            hideLoadingIndicatorIfNeeded()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Welcome", comment: "Product list welcome title")

        installTableView()
        installCustomBackButton()
    }

    private func installCustomBackButton() {
        let backItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )

        backItem.tintColor = .primaryText

        navigationItem.backBarButtonItem = backItem
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Loading state

    private var loadingController: LoadingViewController?

    func showLoadingIndicatorIfNeeded() {
        guard viewModels.isEmpty else { return }

        showLoadingIndicator()
    }

    func showLoadingIndicator() {
        let loading = LoadingViewController()
        loading.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loading.view.frame = view.bounds
        view.addSubview(loading.view)
        addChild(loading)
        loading.didMove(toParent: self)

        loading.show()

        loadingController = loading
    }

    func hideLoadingIndicatorIfNeeded() {
        loadingController?.hide(animated: true, completion: { [weak self] in
            self?.loadingController = nil
        })
    }

    // MARK: - Table View

    private lazy var tableView: UITableView = {
        let v = UITableView()

        v.separatorColor = .clear
        v.separatorInset = UIEdgeInsets()
        v.contentInset = UIEdgeInsets(top: Metrics.padding, left: 0, bottom: 0, right: 0)

        return v
    }()

    private func installTableView() {
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: Constants.productCellIdentifier)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    // MARK: - Scrolling support

    var scrollableContentDidStartIntersectingSafeArea: (() -> Void)?
    var scrollableContentDidStopIntersectingSafeArea: (() -> Void)?

    private var isScrollableContentIntersectingSafeArea = false {
        didSet {
            guard isScrollableContentIntersectingSafeArea != oldValue else { return }

            if isScrollableContentIntersectingSafeArea {
                scrollableContentDidStartIntersectingSafeArea?()
            } else {
                scrollableContentDidStopIntersectingSafeArea?()
            }
        }
    }

}

// MARK: - Table view data source and delegate

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.productCellIdentifier, for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }

        let viewModel = viewModels[indexPath.row]

        cell.viewModel = viewModel

        cell.didReceiveTap = { [unowned self] in
            self.delegate?.productListViewController(self, didSelectViewModel: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaReference = -(scrollView.adjustedContentInset.top - Metrics.padding)

        isScrollableContentIntersectingSafeArea = safeAreaReference < scrollView.contentOffset.y
    }

}
