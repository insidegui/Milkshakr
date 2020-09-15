//
//  Purchase.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 15/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation

public struct Purchase: Model, Hashable, Codable {

    public struct Item: Hashable, Identifiable, Codable {
        public let id: String
        public let title: String
        public let price: Decimal
        public let quantity: Int

        init(product: Product, quantity: Int) {
            self.id = product.id
            self.title = product.name
            self.price = product.price
            self.quantity = quantity
        }
    }

    public let id: UUID
    public let createdAt: Date
    public private(set) var items: [Item]
    public private(set) var total: Decimal

    public init() {
        self.id = UUID()
        self.createdAt = Date()
        self.items = []
        self.total = 0
    }

}

public extension Purchase {
    mutating func add(_ product: Product, quantity: Int) {
        let item = Item(product: product, quantity: quantity)
        items.append(item)

        updateTotal()
    }

    fileprivate mutating func updateTotal() {
        total = items.reduce(Decimal(0), { $0 + ($1.price * Decimal($1.quantity)) })
    }
}
