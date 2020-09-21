//
//  DeepLinkHandler.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 12/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

final class DeepLinkHandler {

    let flowController: AppFlowController

    private let validActivityTypes: [String]

    init(_ flowController: AppFlowController) {
        self.flowController = flowController

        let activityTypes = [
            Constants.userActivityType,
            NSUserActivityTypeBrowsingWeb,
            String(describing: OrderMilkshakeIntent.self)
        ]

        validActivityTypes = activityTypes
    }

    func prepareToHandle(type: String) -> Bool {
        guard validActivityTypes.contains(type) else { return false }

        flowController.goHome()

        return true
    }

    func handle(_ userActivity: NSUserActivity) -> Bool {
        guard validActivityTypes.contains(userActivity.activityType) else { return false }

        let isPurchaseIntent = translateIntentToUserInfo(in: userActivity)

        flowController.pushProductDetail(from: userActivity, purchase: isPurchaseIntent)

        return true
    }

    private func translateIntentToUserInfo(in userActivity: NSUserActivity) -> Bool {
        guard let intent = userActivity.interaction?.intent as? OrderMilkshakeIntent,
              let identifier = intent.product?.identifier
        else { return false }

        userActivity.addUserInfoEntries(from: [ProductViewModel.Keys.identifier: identifier])

        return true
    }

}
