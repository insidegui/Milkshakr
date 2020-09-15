//
//  PurchaseViewModel+Intent.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 12/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import Intents

@available(iOSApplicationExtension 12.0, *)
public extension PurchaseViewModel {

    var intentObject: INObject {
        return INObject(identifier: purchase.items[0].id, display: purchase.items[0].title)
    }

}

@available(iOSApplicationExtension 12.0, *)
public extension PurchaseViewModel {

    var intent: OrderMilkshakeIntent {
        let result = OrderMilkshakeIntent()

        result.suggestedInvocationPhrase = NSString.deferredLocalizedIntentsString(with: "Order %@", purchase.items[0].title) as String
        result.product = intentObject

        return result
    }

    var interaction: INInteraction {
        return INInteraction(intent: intent, response: nil)
    }

}
