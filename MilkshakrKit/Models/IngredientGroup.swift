//
//  IngredientGroup.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation

public struct IngredientGroup: Codable, Hashable {

    public let name: String
    public let disclaimer: String
    public let ingredients: [Ingredient]

    public init(name: String, disclaimer: String, ingredients: [Ingredient]) {
        self.name = name
        self.disclaimer = disclaimer
        self.ingredients = ingredients
    }

}
