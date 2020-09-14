//
//  Account.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation

public struct Account: Model, Hashable, Codable {
    public let id: String
    public let name: String
}
