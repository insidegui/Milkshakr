//
//  PurchaseViewModel.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 11/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit

public struct PurchaseViewModel {

    public let product: Product

    public init(product: Product) {
        self.product = product
    }

    public var title: String {
        return NSLocalizedString("Success!", comment: "Title for purchase success screen")
    }

    private static let messageParagraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()

        style.lineSpacing = Metrics.successDescriptionLineHeight
        style.alignment = .center

        return style
    }()

    private static let messageAttributes: [NSAttributedString.Key: Any] = {
        return [
            .foregroundColor: UIColor.secondaryText,
            .font: UIFont.systemFont(ofSize: Metrics.successDescriptionFontSize, weight: Metrics.successDescriptionFontWeight),
            .paragraphStyle: messageParagraphStyle
        ]
    }()

    private static let messageNotificationInfoAttributes: [NSAttributedString.Key: Any] = {
        return [
            .foregroundColor: UIColor.success,
            .font: UIFont.systemFont(ofSize: Metrics.successDescriptionFontSize, weight: Metrics.successDescriptionFontWeight),
            .paragraphStyle: messageParagraphStyle
        ]
    }()

    public var attributedMessage: NSAttributedString {
        let result = NSMutableAttributedString()

        let introFormat = NSLocalizedString("Your delicious %@ is being prepared, ", comment: "Introduction to purchase success message")
        let intro = String(format: introFormat, product.name)

        result.append(NSAttributedString(string: intro, attributes: PurchaseViewModel.messageAttributes))

        let notificationInfo = NSLocalizedString("we'll send you a notification once it's ready for pickup.", comment: "Continuation for the purchase success message explaining that the user should get a notification in a few minutes")
        result.append(NSAttributedString(string: notificationInfo, attributes: PurchaseViewModel.messageNotificationInfoAttributes))

        return result.copy() as! NSAttributedString
    }

    public var attributedSiriMessage: NSAttributedString {
        let result = NSMutableAttributedString()

        let messageFormat = NSLocalizedString("Wanna order more quickly in the future?\nAdd \"%@\" to Siri!", comment: "Message asking the user to add a previously purchased product shortcut to Siri")
        let message = String(format: messageFormat, product.name)

        result.append(NSAttributedString(string: message, attributes: PurchaseViewModel.messageAttributes))

        return result.copy() as! NSAttributedString
    }

    public var addToSiriButtonTitle: String {
        return NSLocalizedString("Add to Siri", comment: "Title for the add to Siri button")
    }

}
