//
//  AppDelegate.swift
//  Clip
//
//  Created by Guilherme Rambo on 21/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MilkshakrKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationManager.shared.setup()

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.mskRoundedSystemFont(ofSize: 36, weight: .bold)
        ]

        NotificationManager.shared.requestAuthorization(provisional: true)
        
        return true
    }

}

