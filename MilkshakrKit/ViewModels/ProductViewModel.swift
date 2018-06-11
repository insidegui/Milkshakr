//
//  ProductViewModel.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit

public struct ProductViewModel {

    public let product: Product

    public init(product: Product) {
        self.product = product
    }

    public var title: String {
        return product.name
    }

    private static let descriptionAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = Metrics.productDescriptionLineHeight

        return [
            .foregroundColor: UIColor.secondaryText,
            .paragraphStyle: style,
            .font: UIFont.systemFont(ofSize: Metrics.productDescriptionFontSize)
        ]
    }()

    private static let ingredientGroupTitleAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = Metrics.productDescriptionLineHeight

        return [
            .foregroundColor: UIColor.primaryText,
            .paragraphStyle: style,
            .font: UIFont.systemFont(ofSize: Metrics.ingredientGroupNameFontSize, weight: Metrics.ingredientGroupNameFontWeight)
        ]
    }()

    private static let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()

        f.numberStyle = .currency
        f.currencyCode = "BRL"

        return f
    }()

    public var attributedDescription: NSAttributedString {
        return NSAttributedString(string: product.description, attributes: ProductViewModel.descriptionAttributes)
    }

    public var formattedPrice: String {
        let effectivePrice = product.discountPrice ?? product.price

        return ProductViewModel.priceFormatter.string(for: effectivePrice) ?? "ERROR"
    }

    public var image: UIImage? {
        return UIImage(named: product.imageName, in: .milkshakrKit, compatibleWith: nil)
    }

    public var attributedIngredientGroups: NSAttributedString {
        let result = NSMutableAttributedString()

        product.ingredientGroups.forEach { group in
            let attributedTitle = NSAttributedString(string: group.name + "\n", attributes: ProductViewModel.ingredientGroupTitleAttributes)

            var info = group.ingredients.map({ $0.name }).joined(separator: ", ")
            info += ". \(group.disclaimer)\n\n"

            let attributedInfo = NSAttributedString(string: info, attributes: ProductViewModel.descriptionAttributes)

            result.append(attributedTitle)
            result.append(attributedInfo)
        }

        return result.copy() as! NSAttributedString
    }

}
