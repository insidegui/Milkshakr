//
//  UIFont+Rounded.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 14/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit

public extension UIFont {

    static func mskRoundedSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        guard let desc = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded) else {
            assertionFailure("Failed to get font descriptor")
            return UIFont.systemFont(ofSize: size, weight: weight)
        }

        return UIFont(descriptor: desc, size: size)
    }

    static func configureNavBarFont() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.mskRoundedSystemFont(ofSize: 36, weight: .bold)
        ]
    }

}
