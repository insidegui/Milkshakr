//
//  ProductDetailsViewController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit
import PassKit

protocol ProductDetailsViewControllerDelegate: class {
    func productDetailsViewController(_ controller: ProductDetailsViewController, didSelectPurchase purchase: Product)
}

final class ProductDetailsViewController: UIViewController {

    weak var delegate: ProductDetailsViewControllerDelegate?

    let viewModel: ProductViewModel
    let purchaseImmediately: Bool

    init(viewModel: ProductViewModel, purchaseImmediately: Bool = false) {
        self.viewModel = viewModel
        self.purchaseImmediately = purchaseImmediately

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var imageView: UIImageView = {
        let v = UIImageView()

        v.heightAnchor.constraint(equalToConstant: Metrics.productImageHeight).isActive = true
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.systemFont(ofSize: Metrics.largeTitleFontSize, weight: Metrics.largeTitleFontWeight)
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail

        return l
    }()

    private lazy var ingredientsTitleLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.systemFont(ofSize: Metrics.largeTitleFontSize, weight: Metrics.largeTitleFontWeight)
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail

        return l
    }()

    private lazy var priceLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.systemFont(ofSize: Metrics.priceFontSize, weight: Metrics.priceFontWeight)
        l.textAlignment = .right
        l.textColor = .primaryText
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false

        return l
    }()

    private lazy var productDescriptionLabel: UILabel = {
        let l = UILabel()

        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setContentCompressionResistancePriority(.required, for: .vertical)

        return l
    }()

    private lazy var ingredientGroupsLabel: UILabel = {
        let l = UILabel()

        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setContentCompressionResistancePriority(.required, for: .vertical)

        return l
    }()

    private lazy var contentStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            titleLabel,
            productDescriptionLabel,
            ingredientsTitleLabel,
            ingredientGroupsLabel
        ])

        v.axis = .vertical
        v.spacing = Metrics.smallPadding
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()

        v.alwaysBounceVertical = true
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    private lazy var purchaseButton: PKPaymentButton = {
        let b = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: UIColor.paymentButtonStyle)

        b.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: Metrics.purchaseButtonHeight).isActive = true

        return b
    }()

    private lazy var buttonBackground: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: .light))

        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    @objc private func purchase() {
        delegate?.productDetailsViewController(self, didSelectPurchase: viewModel.product)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userActivity = viewModel.userActivity

        view.backgroundColor = .background

        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        scrollView.addSubview(contentStack)
        contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true

        view.addSubview(buttonBackground)
        view.addSubview(purchaseButton)
        purchaseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metrics.padding).isActive = true

        buttonBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonBackground.topAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -Metrics.padding).isActive = true

        updateUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        initiatePurchaseIfNeeded()
    }

    private var didInitiatePurchase = false

    private func initiatePurchaseIfNeeded() {
        guard purchaseImmediately, !didInitiatePurchase else { return }
        didInitiatePurchase = true

        purchase()
    }

    override func updateUserActivityState(_ activity: NSUserActivity) {
        activity.addUserInfoEntries(from: viewModel.activityUserInfo)
    }

    private func updateUI() {
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        productDescriptionLabel.attributedText = viewModel.attributedDescription
        ingredientsTitleLabel.text = NSLocalizedString("Ingredients", comment: "Ingredients (title for the list of ingredients)")
        ingredientGroupsLabel.attributedText = viewModel.attributedIngredientGroups

        contentStack.layoutIfNeeded()
        scrollView.contentSize = scrollView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        scrollView.contentInset = UIEdgeInsets(top: Metrics.padding, left: 0, bottom: Metrics.purchaseButtonHeight, right: 0)
    }

}
