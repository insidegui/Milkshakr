//
//  PurchaseSuccessViewController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 11/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

protocol PurchaseSuccessViewControllerDelegate: class {
    func purchaseSuccessViewControllerDidSelectAddToSiri(_ controller: PurchaseSuccessViewController)
}

final class PurchaseSuccessViewController: UIViewController {

    weak var delegate: PurchaseSuccessViewControllerDelegate?

    let viewModel: PurchaseViewModel

    init(viewModel: PurchaseViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var iconView: UIImageView = {
        let v = UIImageView()

        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: Metrics.successIconWidth).isActive = true
        v.heightAnchor.constraint(equalToConstant: Metrics.successIconHeight).isActive = true
        v.image = #imageLiteral(resourceName: "success")

        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.systemFont(ofSize: Metrics.largeTitleFontSize, weight: Metrics.largeTitleFontWeight)
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center

        return l
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()

        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center

        return l
    }()

    private lazy var siriMessageLabel: UILabel = {
        let l = UILabel()

        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .center

        return l
    }()

    private lazy var addToSiriButton: UIButton = {
        let b = UIButton(type: .system)

        b.titleLabel?.font = UIFont.systemFont(ofSize: Metrics.addToSiriButtonFontSize, weight: Metrics.addToSiriButtonFontWeight)
        b.addTarget(self, action: #selector(addToSiri), for: .touchUpInside)

        return b
    }()

    private lazy var doneButton: UIButton = {
        let b = UIButton(type: .system)

        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(NSLocalizedString("Done", comment: "Done button title"), for: .normal)

        return b
    }()

    private lazy var siriMessageStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [siriMessageLabel, addToSiriButton])

        v.axis = .vertical
        v.spacing = Metrics.padding
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func addToSiri() {
        delegate?.purchaseSuccessViewControllerDidSelectAddToSiri(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        buildUI()
        updateUI()
    }

    private func buildUI() {
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(siriMessageStack)
        view.addSubview(doneButton)

        doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.smallPadding).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.smallPadding).isActive = true

        iconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.successTitleToSafeAreaMargin).isActive = true
        iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Metrics.smallPadding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding).isActive = true

        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.successTitleToDescriptionMargin).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true

        siriMessageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        siriMessageStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        siriMessageStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    }

    private func updateUI() {
        titleLabel.text = viewModel.title
        messageLabel.attributedText = viewModel.attributedMessage
        siriMessageLabel.attributedText = viewModel.attributedSiriMessage
        addToSiriButton.setTitle(viewModel.addToSiriButtonTitle, for: .normal)
    }

}
