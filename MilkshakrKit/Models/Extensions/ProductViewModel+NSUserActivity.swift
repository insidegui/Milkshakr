//
//  ProductViewModel+NSUserActivity.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 12/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreSpotlight

public extension ProductViewModel {

    struct Keys {
        public static let identifier = "pid"
    }

    var activityUserInfo: [String: String] {
        return [Keys.identifier: product.identifier]
    }

    var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: Constants.userActivityType)

        activity.isEligibleForSearch = true

        if #available(iOSApplicationExtension 12.0, *) {
            activity.isEligibleForPrediction = true
        }

        activity.title = title
        activity.requiredUserInfoKeys = Set([Keys.identifier])
        activity.userInfo = activityUserInfo

        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.thumbnailData = image?.pngData()
        attributes.contentDescription = attributedDescription.string

        activity.contentAttributeSet = attributes

        return activity
    }

}
