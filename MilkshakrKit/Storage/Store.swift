//
//  Store.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case error(Error)
}

public protocol Store {
    associatedtype Model
    typealias StoreCompletionBlock = (Result<Model>) -> Void
    typealias StoreCollectionCompletionBlock = (Result<[Model]>) -> Void

    func store(models: [Model], completion: @escaping StoreCollectionCompletionBlock)
    func fetchAll(completion: @escaping StoreCollectionCompletionBlock)
    func fetch(with identifier: String, completion: @escaping StoreCompletionBlock)
    func fetch(from userActivity: NSUserActivity, completion: @escaping StoreCompletionBlock)
}
