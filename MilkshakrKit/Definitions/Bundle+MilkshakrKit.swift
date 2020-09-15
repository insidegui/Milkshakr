//
//  Bundle+MilkshakrKit.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Foundation

private final class _StubForBundleInit { }

public extension Bundle {

    static var milkshakrKit: Bundle {
        return Bundle(for: _StubForBundleInit.self)
    }

}
