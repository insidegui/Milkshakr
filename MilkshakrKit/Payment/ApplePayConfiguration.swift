//
//  ApplePayConfiguration.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation
import PassKit

public struct ApplePayConfiguration {
    public static let countryCode = "BR"
    public static let currencyCode = "BRL"
    public static let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex, .discover, .elo]
    public static let merchantCapabilities: PKMerchantCapability = [.capability3DS, .capabilityCredit, .capabilityDebit]
    public static let merchantIdentifier = "merchant.com.nsbrltda.sample.Milkshakr"

    public static func configure(_ request: PKPaymentRequest) {
        request.countryCode = countryCode
        request.currencyCode = currencyCode
        request.supportedNetworks = supportedNetworks
        request.merchantCapabilities = merchantCapabilities
        request.merchantIdentifier = merchantIdentifier
    }
}
