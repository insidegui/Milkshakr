//
//  UserDefaults+AppGroup.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 21/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation

public extension UserDefaults {
    static let mskAppGroup: UserDefaults = {
        guard let instance = UserDefaults(suiteName: "group.br.com.guilhermerambo.Milkshakr.Shared") else {
            assertionFailure("Failed to instantiate UserDefaults for the shared App Group. Make sure this target's capabilities are configured properly.")
            return .standard
        }

        return instance
    }()
}
