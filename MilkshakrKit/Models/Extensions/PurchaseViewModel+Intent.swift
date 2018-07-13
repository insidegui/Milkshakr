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
public extension Product {

    var intentObject: INObject {
        return INObject(identifier: identifier, display: name)
    }

}

@available(iOSApplicationExtension 12.0, *)
public extension PurchaseViewModel {

    // -> intent and interaction

}
