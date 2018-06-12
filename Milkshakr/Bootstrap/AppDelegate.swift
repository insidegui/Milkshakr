//
//  AppDelegate.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var store: ProductStore = {
        return ProductStore()
    }()

    private lazy var flowController: AppFlowController = {
        return AppFlowController(store: store)
    }()

    private lazy var deepLinkHandler: DeepLinkHandler = {
        return DeepLinkHandler(flowController)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = flowController
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return deepLinkHandler.prepareToHandle(type: userActivityType)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return deepLinkHandler.handle(userActivity)
    }

}

