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

    private var backingStore: [Product] = Product.demoProducts

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

extension Product {

    static let demoProducts: [Product] = [
        Product(
            identifier: UUID().uuidString,
            name: "Chocolate Shake",
            description: "Chocolate Shake featuring our deliciously creamy vanilla soft serve and chocolate syrup, topped with whipped topping. Available in Small, Medium, and Large.",
            imageName: "chocolate_shake",
            price: Decimal(12.99),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Strawberry Shake",
            description: "Strawberry Shake made with creamy vanilla soft serve, blended with strawberry flavored deliciousness, topped with whipped topping. Available in Small, Medium, and Large.",
            imageName: "strawberry_shake",
            price: Decimal(18.99),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Vanilla Shake",
            description: "The classic vanilla shake, made with our creamy vanilla soft serve, topped with whipped topping. Available in Small, Medium, and Large.",
            imageName: "vanilla_shake",
            price: Decimal(8.99),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Vanilla Cone",
            description: "Enjoy a treat made with sweet, creamy vanilla soft serve in a crispy cone.",
            imageName: "vanilla_cone",
            price: Decimal(14.99),
            discountPrice: Decimal(9.89),
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Hot Fudge Sundae",
            description: "A classic hot fudge sundae made with vanilla soft serve, smothered in chocolaty fudge sauce.",
            imageName: "hot_fudge_sundae",
            price: Decimal(18.9),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "M&M’S® Shake",
            description: "Made from vanilla soft serve with colorful chocolate candies swirled in. Enjoy these classic M&M’S® desserts in Regular Size and Snack Size.",
            imageName: "mm_shake",
            price: Decimal(15.89),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Kiddie Cone",
            description: "A delightful dessert of creamy vanilla McDonald’s soft serve in a crispy mini cone.",
            imageName: "kiddie_cone",
            price: Decimal(2.99),
            discountPrice: nil,
            isSoldOut: true,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Hot Caramel Sundae",
            description: "A caramel sundae that combines cool and creamy vanilla soft serve with warm, rich, buttery caramel.",
            imageName: "hot_caramel_sundae",
            price: Decimal(23.99),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        ),
        Product(
            identifier: UUID().uuidString,
            name: "Strawberry Sundae",
            description: "Creamy vanilla soft serve topped with sliced strawberries in a sweet and tart strawberry topping.",
            imageName: "strawberry_sundae",
            price: Decimal(14.89),
            discountPrice: nil,
            isSoldOut: false,
            ingredientGroups: IngredientGroup.demoGroups
        )
    ]

}
