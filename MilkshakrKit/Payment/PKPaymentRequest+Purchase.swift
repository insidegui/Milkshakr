//
//  PKPaymentRequest+Purchase.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 15/07/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentRequest {

    public convenience init(with purchase: Purchase) {
        self.init()

        ApplePayConfiguration.configure(self)

        let summaryItems: [PKPaymentSummaryItem] = purchase.items.map { item in
            return PKPaymentSummaryItem(label: item.title, amount: NSDecimalNumber(decimal: Decimal(item.quantity) * item.price))
        }

        let total: NSDecimalNumber = NSDecimalNumber(decimal: purchase.total)
        let totalItem = PKPaymentSummaryItem(label: "Total", amount: total, type: .final)

        paymentSummaryItems = summaryItems + [totalItem]
    }

}
