//
//  SceneDelegate.swift
//  Clip
//
//  Created by Guilherme Rambo on 21/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let productStore = ProductStore()
    private let accountStore = AccountStore()

    private lazy var flow: AppClipFlowController = {
        AppClipFlowController(
            accountStore: accountStore,
            productStore: productStore
        )
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = flow
        window?.makeKeyAndVisible()

        if let activity = connectionOptions.userActivities.first { flow.handle(activity) }
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        flow.productListingFlow.goHome()
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        flow.handle(userActivity)
    }

}

