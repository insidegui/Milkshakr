//
//  AccountStore.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import AuthenticationServices

public final class AccountStore: NSObject, DeletableStore, ObservableObject {

    /// Returns the currently signed in account, if any.
    @Published public private(set) var signedInAccount: Account?

    /// Returns the purchase history for the currently logged in user.
    @Published public private(set) var purchases: [Purchase] = []

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        super.init()

        loadLocalData()
    }

    public typealias Model = Account

    public func store(models: [Account], completion: @escaping StoreCollectionCompletionBlock) {
        precondition(models.count == 1, "Only a single account can be stored at any given time")
        precondition(signedInAccount == nil, "Can't store an account while we already have a signed in account. Sign out before doing that.")

        signedInAccount = models.first
    }

    public func fetchAll(completion: @escaping StoreCollectionCompletionBlock) {
        fatalError("Not supported")
    }

    public func fetch(with identifier: String, completion: @escaping StoreCompletionBlock) {

    }

    public func fetch(from userActivity: NSUserActivity, completion: @escaping StoreCompletionBlock) {
        fatalError("Not supported")
    }

    // MARK: - Purchase History

    public func store(_ purchase: Purchase) {
        _purchaseHistoryStorage.append(purchase)
    }

    // MARK: - Sign in with Apple

    private weak var signInWithApplePresenter: UIViewController?

    func signInWithApple(from presenter: UIViewController, completion: @escaping () -> Void) {
        signInWithApplePresenter = presenter

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}

extension AccountStore: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = signInWithApplePresenter?.view.window else {
            preconditionFailure("Must have a view controller set as the presenter and it must be in a window")
        }

        return window
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            presentSignInWithAppleError(with: "Unable to obtain credential")
            return
        }

        let name: String

        if let components = credential.fullName {
            name = PersonNameComponentsFormatter().string(from: components)
        } else {
            name = "(No Name)"
        }

        _storedAccount = Account(id: credential.email ?? "johndoe@example.com", name: name)
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        presentSignInWithAppleError(with: error.localizedDescription)
    }

    private func presentSignInWithAppleError(with message: String) {
        let alert = UIAlertController(title: "Sign In Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        signInWithApplePresenter?.present(alert, animated: true, completion: nil)
    }

    public func delete(with identifier: String) {
        // not really checking if the identifier matches what we have, it's a demo after all...
        _storedAccount = nil
    }
    
}




















// MARK: - Local storage

private extension AccountStore {

    /*
     ################ SAMPLE CODE WARNING ################
     In a shipping app, NEVER store a user's sensitive account data in UserDefaults.
     This is just a sample project. In production code, you must use the Keychain to store this type of information.
     ################ SAMPLE CODE WARNING ################
     */

    var _storedAccount: Account? {
        get {
            guard let data = defaults.data(forKey: #function) else { return nil }
            guard let account = try? PropertyListDecoder().decode(Account.self, from: data) else {
                assertionFailure("Failed to decode account model")
                return nil
            }
            return account
        }
        set {
            defer {
                // Delete purchase history when changing user accounts.
                if newValue?.id != _storedAccount?.id {
                    _purchaseHistoryStorage = []
                }
            }

            guard let newValue = newValue else {
                defaults.removeObject(forKey: #function)
                signedInAccount = nil
                return
            }

            guard let data = try? PropertyListEncoder().encode(newValue) else {
                preconditionFailure("Failed to encode account model")
            }

            defaults.set(data, forKey: #function)
            signedInAccount = newValue
        }
    }

    var _purchaseHistoryStorage: [Purchase] {
        get {
            guard let data = defaults.data(forKey: #function) else { return [] }
            guard let purchases = try? PropertyListDecoder().decode([Purchase].self, from: data) else {
                assertionFailure("Failed to decode purchases")
                return []
            }
            return purchases
        }
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else {
                preconditionFailure("Failed to encode account model")
            }

            defaults.set(data, forKey: #function)
            loadPurchaseHistory(from: newValue)
        }
    }

    private func loadLocalData() {
        #if DEBUG
        if UserDefaults.standard.bool(forKey: "MSKDeletePurchases") {
            _purchaseHistoryStorage = []
        }
        #endif

        signedInAccount = _storedAccount
        loadPurchaseHistory(from: _purchaseHistoryStorage)
    }

    private func loadPurchaseHistory(from list: [Purchase]) {
        purchases = list.sorted(by: { $0.createdAt > $1.createdAt })
    }

}

// MARK: - Preview Support

#if DEBUG

public extension AccountStore {
    func preview_setPurchaseHistory(_ purchases: [Purchase]) {
        self.purchases = purchases
    }
}

#endif
