//
//  PKPaymentRequest+Product.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 15/07/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentRequest {

    public convenience init(with products: [Product]) {
        self.init()

        ApplePayConfiguration.configure(self)

        let summaryItems: [PKPaymentSummaryItem] = products.map { product in
            let effectivePrice = product.discountPrice ?? product.price
            return PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(decimal: effectivePrice))
        }

        let total: NSDecimalNumber = summaryItems.reduce(NSDecimalNumber(value: 0), { $0.adding($1.amount) })
        let totalItem = PKPaymentSummaryItem(label: "Total", amount: total, type: .final)

        paymentSummaryItems = summaryItems + [totalItem]
    }

}
