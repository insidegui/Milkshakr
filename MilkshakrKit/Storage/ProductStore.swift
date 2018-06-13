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

    private let fakeNetworkingDelay: TimeInterval = 0.5

    private lazy var backingStore: [Product] = {
        guard let url = Bundle.milkshakrKit.url(forResource: "demo", withExtension: "json") else {
            fatalError("Missing demo.json from MilkshakrKit resources")
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            fatalError("Failed to load demo content: \(String(describing: error))")
        }
    }()

    public func fetchAll(completion: @escaping (Result<[Product]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + fakeNetworkingDelay) {
            completion(.success(self.backingStore))
        }
    }

    public func fetch(with identifier: String, completion: @escaping (Result<Product>) -> Void) {
        guard let model = backingStore.first(where: { $0.identifier == identifier }) else {
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

extension Ingredient {

    static let cornSyrup = Ingredient(name: "Corn Syrup")
    static let water = Ingredient(name: "Water")
    static let milk = Ingredient(name: "Milk", isAllergen: true)
    static let caramelColor = Ingredient(name: "Caramel Color")
    static let naturalFlavor = Ingredient(name: "Natural Flavor")
    static let salt = Ingredient(name: "Salt")
    static let citricAcid = Ingredient(name: "Citric Acid")
    static let potassiumSorbate = Ingredient(name: "Potassium Sorbate (Preservative)")
    static let pectin = Ingredient(name: "Pectin")
    static let sugar = Ingredient(name: "Sugar")
    static let cream = Ingredient(name: "Cream")
    static let nonfatMilk = Ingredient(name: "Nonfat Milk", isAllergen: true)
    static let liquidSugar = Ingredient(name: "Liquid Sugar")

}

extension IngredientGroup {

    static let demoGroups: [IngredientGroup] = [
        IngredientGroup(name: "Ice Cream", disclaimer: "", ingredients: [.milk, .sugar, .cream, .cornSyrup, .naturalFlavor]),
        IngredientGroup(name: "Syrup", disclaimer: "May contain small amounts of other shake flavors served at the restaurant.", ingredients: [.cornSyrup, .water, .caramelColor, .naturalFlavor, .salt, .citricAcid, .potassiumSorbate, .pectin, .sugar]),
        IngredientGroup(name: "Whipped Cream", disclaimer: "Contains 2% or Less: Mono and Diglycerides, Natural Flavors, Carrageenan. Whipping Propellant (Nitrous Oxide).", ingredients: [.cream, .nonfatMilk, .liquidSugar])
    ]

}
