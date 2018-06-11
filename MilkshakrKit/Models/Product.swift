//
//  Product.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation

public struct Product: Model {
    public let identifier: String
    public let name: String
    public let description: String
    public let imageName: String
    public let price: Decimal
    public let discountPrice: Decimal?
    public let isSoldOut: Bool
    public let ingredientGroups: [IngredientGroup]

    public init(identifier: String,
                name: String,
                description: String,
                imageName: String,
                price: Decimal,
                discountPrice: Decimal?,
                isSoldOut: Bool,
                ingredientGroups: [IngredientGroup])
    {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.imageName = imageName
        self.price = price
        self.discountPrice = discountPrice
        self.isSoldOut = isSoldOut
        self.ingredientGroups = ingredientGroups
    }
}
