//
//  AccountHomeViewController.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit
import AuthenticationServices
import Combine

final class AccountHomeViewController: UIViewController {

    let viewModel: AccountViewModel

    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)

        title = "Account"
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private lazy var signedOutLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = .secondaryText
        l.text = "You're not currently logged in. Log in to save your order history and earn rewards!"
        l.numberOfLines = 0
        l.textAlignment = .center

        return l
    }()

    private lazy var logInButton: ASAuthorizationAppleIDButton = {
        let v = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)

        v.heightAnchor.constraint(equalToConstant: 44).isActive = true
        v.widthAnchor.constraint(equalToConstant: 200).isActive = true
        v.cornerRadius = 22
        v.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        return v
    }()

    private lazy var signedOutView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [signedOutLabel, logInButton])

        v.axis = .vertical
        v.spacing = 16
        v.distribution = .equalSpacing
        v.alignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .background

        view.addSubview(signedOutView)

        NSLayoutConstraint.activate([
            signedOutView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signedOutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signedOutView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$state.sink { [weak self] state in
            self?.updateState(state)
        }.store(in: &cancellables)
    }

    @objc private func signIn() {
        viewModel.signIn(from: self)
    }

    private func updateState(_ state: AccountViewModel.State) {
        switch state {
        case .loggedIn(let account):
            showSignedInState(with: account)
        case .loggedOut:
            showSignedOutState()
        }
    }

    private func showSignedInState(with account: Account) {
        signedOutView.isHidden = true
    }

    private func showSignedOutState() {
        signedOutView.isHidden = false
    }

}
