//
//  ProductTableViewCell.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit

public final class ProductTableViewCell: UITableViewCell {

    private lazy var productView = ProductView(frame: .zero)

    public var viewModel: ProductViewModel? {
        get {
            return productView.viewModel
        }
        set {
            productView.viewModel = newValue
        }
    }

    public var didReceiveTap: (() -> Void)? {
        get {
            return productView.didReceiveTap
        }
        set {
            productView.didReceiveTap = newValue
        }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        buildUI()
    }

    private func buildUI() {
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productView)

        productView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding).isActive = true
        productView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding).isActive = true
        productView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.padding).isActive = true
        productView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.padding).isActive = true
    }

}
