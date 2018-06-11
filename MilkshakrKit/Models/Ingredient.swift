//
//  Ingredient.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation

public struct Ingredient {

    public let name: String
    public let isAllergen: Bool

    public init (name: String, isAllergen: Bool = false) {
        self.name = name
        self.isAllergen = isAllergen
    }

}
