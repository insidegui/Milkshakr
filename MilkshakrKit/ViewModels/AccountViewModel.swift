//
//  AccountViewModel.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import Combine

public final class AccountViewModel: ObservableObject {

    let store: AccountStore

    private var cancellables = [AnyCancellable]()

    public enum State {
        case loggedIn(Account)
        case loggedOut
    }

    @Published public private(set) var state = State.loggedOut

    public init(store: AccountStore) {
        self.store = store

        store.$signedInAccount.map({ $0 != nil ? State.loggedIn($0!) : State.loggedOut })
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }

    public func signIn(from presenter: UIViewController) {
        store.signInWithApple(from: presenter, completion: { })
    }

}
