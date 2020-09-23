//
//  SceneDelegate.swift
//  Clip
//
//  Created by Guilherme Rambo on 23/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var flow: ClipFlowController = {
        ClipFlowController()
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = flow
        window?.makeKeyAndVisible()
    }

}

