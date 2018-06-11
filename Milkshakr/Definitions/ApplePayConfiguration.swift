//
//  ApplePayConfiguration.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation
import PassKit

struct ApplePayConfiguration {
    static let countryCode = "BR"
    static let currencyCode = "BRL"
    static let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard]
    static let merchantCapabilities: PKMerchantCapability = [.capability3DS]
    static let merchantIdentifier = "merchant.br.com.guilhermerambo.milshakrdemo"

    static func configure(_ request: PKPaymentRequest) {
        request.countryCode = countryCode
        request.currencyCode = currencyCode
        request.supportedNetworks = supportedNetworks
        request.merchantCapabilities = merchantCapabilities
        request.merchantIdentifier = merchantIdentifier
    }
}
