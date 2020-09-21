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

    private lazy var productStore: ProductStore = {
        return ProductStore()
    }()

    private lazy var accountStore: AccountStore = {
        return AccountStore()
    }()

    private lazy var flowController: AppFlowController = {
        AppFlowController(
            accountStore: accountStore,
            productStore: productStore
        )
    }()

    private lazy var deepLinkHandler: DeepLinkHandler = {
        return DeepLinkHandler(flowController)
    }()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationManager.shared.setup()

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppearance()

        window = UIWindow()
        window?.rootViewController = flowController
        window?.makeKeyAndVisible()

        NotificationManager.shared.requestAuthorization()

        return true
    }

    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return deepLinkHandler.prepareToHandle(type: userActivityType)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return deepLinkHandler.handle(userActivity)
    }

}

// MARK: - Appearance

fileprivate extension AppDelegate {
    func configureAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.mskRoundedSystemFont(ofSize: 36, weight: .bold)
        ]
    }
}
