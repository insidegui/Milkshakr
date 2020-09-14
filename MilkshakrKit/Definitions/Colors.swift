//
//  Colors.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import PassKit

private enum Theme: Int {
    case light

    static var current: Theme {
        return .light
    }
}

private protocol ColorStore {
    static var background: UIColor { get }
    static var primaryText: UIColor { get }
    static var secondaryText: UIColor { get }
    static var success: UIColor { get }
    static var paymentButtonStyle: PKPaymentButtonStyle { get }
}

private struct SystemTheme: ColorStore {
    static let background: UIColor = .systemBackground
    static let primaryText: UIColor = .label
    static let secondaryText: UIColor = .secondaryLabel
    static var paymentButtonStyle: PKPaymentButtonStyle {
        if #available(iOS 14.0, *) {
            return .automatic
        } else {
            return .black
        }
    }
    static let success: UIColor = UIColor(red: 49.0 / 255.0, green: 175.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
}

extension UIColor: ColorStore {

    private static var colorStore: ColorStore.Type { SystemTheme.self }

    public static var background: UIColor {
        return colorStore.background
    }

    public static var primaryText: UIColor {
        return colorStore.primaryText
    }

    public static var secondaryText: UIColor {
        return colorStore.secondaryText
    }

    public static var paymentButtonStyle: PKPaymentButtonStyle {
        return colorStore.paymentButtonStyle
    }

    public static var success: UIColor {
        return colorStore.success
    }
    
}
