//
//  ProductStore.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation

public final class ProductStore: Store {

    public enum FetchError: Error {
        case notFound(String)
        case parse(String)

        var localizedDescription: String {
            switch self {
            case .parse(let key):
                return String(format: NSLocalizedString("Unable to parse key %@ from activity", comment: "Unable to parse user activity error"), key)
            case .notFound(let identifier):
                return String(format: NSLocalizedString("Unable to find product with identifier %@", comment: "Product not found error"), identifier)
            }
        }
    }

    public init() {
        
    }

    public typealias Model = Product

    private let fakeNetworkingDelay: TimeInterval = 0.1

    private lazy var backingStore = Bundle.milkshakrKit.loadDemoProducts()

    public func fetchAll(completion: @escaping (Result<[Product]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + fakeNetworkingDelay) {
            completion(.success(self.backingStore))
        }
    }

    public func fetch(with identifier: String, completion: @escaping (Result<Product>) -> Void) {
        guard let model = backingStore.first(where: { $0.id == identifier }) else {
            completion(.error(FetchError.notFound(identifier)))
            return
        }

        completion(.success(model))
    }

    public func store(models: [Product], completion: @escaping (Result<[Product]>) -> Void) {
        fatalError("Demo does not support storage")
    }

    public func fetch(from userActivity: NSUserActivity, completion: @escaping (Result<Product>) -> Void) {
        let key = ProductViewModel.Keys.identifier

        guard let productIdentifier = userActivity.userInfo?[key] as? String else {
            completion(.error(FetchError.parse(key)))
            return
        }

        fetch(with: productIdentifier, completion: completion)
    }

}

public extension Bundle {
    func loadDemoProducts() -> [Product] {
        guard let demoDataURL = url(forResource: "demo", withExtension: "json") else {
            fatalError("Missing demo.json from MilkshakrKit resources")
        }

        do {
            let data = try Data(contentsOf: demoDataURL)
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            fatalError("Failed to load demo content: \(String(describing: error))")
        }
    }
}
