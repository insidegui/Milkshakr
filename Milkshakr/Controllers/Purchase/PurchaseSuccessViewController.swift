//
//  PurchaseSuccessViewController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 11/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit
import Combine
import AuthenticationServices
import StoreKit

protocol PurchaseSuccessViewControllerDelegate: class {
    func purchaseSuccessViewControllerDidSelectAddToSiri(_ controller: PurchaseSuccessViewController)
    func purchaseSuccessViewControllerDidSelectEnableNotifications(_ controller: PurchaseSuccessViewController)
    func purchaseSuccessViewControllerDidSelectSignUp(_ controller: PurchaseSuccessViewController)
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

    #if APPCLIP
    var shouldShowSignUpMessage = false {
        didSet {
            signUpMessageStack.isHidden = !shouldShowSignUpMessage
        }
    }
    #endif

    private var cancellables = [AnyCancellable]()

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

        l.font = UIFont.mskRoundedSystemFont(ofSize: Metrics.largeTitleFontSize, weight: Metrics.largeTitleFontWeight)
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

    private lazy var notificationPermissionButton: UIButton = {
        let b = UIButton(type: .system)

        b.setTitle(NSLocalizedString("Enable Notifications", comment: "Button to let the user allow the app to send notifications"), for: .normal)
        b.addTarget(self, action: #selector(enableNotifications), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false

        return b
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

    private lazy var signUpLabel: UILabel = {
        let l = UILabel()

        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .center
        l.text = NSLocalizedString("Sign up to keep track of your purchases and earn points when you become a member of our Prime program!", comment: "Sign up incentive message")

        return l
    }()

    private lazy var signUpButton: ASAuthorizationAppleIDButton = {
        let v = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)

        v.heightAnchor.constraint(equalToConstant: 44).isActive = true
        v.widthAnchor.constraint(equalToConstant: 200).isActive = true
        v.cornerRadius = 22
        v.addTarget(self, action: #selector(signUp), for: .touchUpInside)

        return v
    }()

    private lazy var signUpMessageStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])

        v.axis = .vertical
        v.spacing = Metrics.padding
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
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

        view.backgroundColor = .background

        buildUI()
        updateUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        #if APPCLIP
        guard let scene = view.window?.windowScene else { return }

        let config = SKOverlay.AppConfiguration(appIdentifier: "1532737553", position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)
        #endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        #if APPCLIP
        guard let scene = view.window?.windowScene else { return }
        SKOverlay.dismiss(in: scene)
        #endif
    }

    private func buildUI() {
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(notificationPermissionButton)
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

        notificationPermissionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Metrics.smallPadding).isActive = true
        notificationPermissionButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        notificationPermissionButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true

        #if APPCLIP
        installSignUpMessage()
        #else
        installSiriMessage()
        #endif
    }

    private func installSiriMessage() {
        view.addSubview(siriMessageStack)

        siriMessageStack.topAnchor.constraint(equalTo: notificationPermissionButton.bottomAnchor, constant: 32).isActive = true

        siriMessageStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        siriMessageStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    }

    private func installSignUpMessage() {
        view.addSubview(signUpMessageStack)

        signUpMessageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        signUpMessageStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        signUpMessageStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    }

    private func updateUI() {
        titleLabel.text = viewModel.title
        messageLabel.attributedText = viewModel.attributedMessage

        #if !APPCLIP
        siriMessageLabel.attributedText = viewModel.attributedSiriMessage
        addToSiriButton.setTitle(viewModel.addToSiriButtonTitle, for: .normal)
        #endif

        NotificationManager.shared.$canAskForNonProvisionalPermission
            .map({ !$0 })
            .assign(to: \.isHidden, on: notificationPermissionButton)
            .store(in: &cancellables)

        #if APPCLIP
        
        #endif
    }

    @objc private func enableNotifications() {
        delegate?.purchaseSuccessViewControllerDidSelectEnableNotifications(self)
    }

    @objc private func signUp() {
        delegate?.purchaseSuccessViewControllerDidSelectSignUp(self)
    }

}
