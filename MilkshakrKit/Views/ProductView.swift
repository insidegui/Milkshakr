//
//  ProductView.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit

public class ProductView: UIView {

    public var didReceiveTap: (() -> Void)?

    public var viewModel: ProductViewModel? {
        didSet {
            updateUI()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        buildUI()
    }

    private lazy var imageContainer: UIView = {
        let v = UIView()

        v.heightAnchor.constraint(equalToConstant: Metrics.productImageHeight).isActive = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setContentCompressionResistancePriority(.required, for: .vertical)
        v.addSubview(imageView)
        v.layer.cornerCurve = imageView.layer.cornerCurve
        v.layer.cornerRadius = imageView.layer.cornerRadius
        v.layer.shadowOpacity = 0.23
        v.layer.shadowRadius = 8
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: -1, height: -1)

        return v
    }()

    private lazy var imageView: UIImageView = {
        let v = UIImageView()

        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.layer.cornerCurve = .continuous
        v.layer.cornerRadius = 16
        v.clipsToBounds = true

        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.mskRoundedSystemFont(ofSize: Metrics.titleFontSize, weight: Metrics.titleFontWeight)
        l.textColor = .primaryText
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false

        return l
    }()

    private lazy var priceLabel: UILabel = {
        let l = UILabel()

        l.font = UIFont.mskRoundedSystemFont(ofSize: Metrics.priceFontSize, weight: Metrics.priceFontWeight)
        l.textAlignment = .right
        l.textColor = .primaryText
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false

        return l
    }()

    private lazy var subtitleLabel: UILabel = {
        let l = UILabel()

        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setContentCompressionResistancePriority(.required, for: .vertical)

        return l
    }()

    private func buildUI() {
        addSubview(imageContainer)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(subtitleLabel)

        imageContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: Metrics.smallPadding).isActive = true

        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -Metrics.padding).isActive = true

        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.smallPadding).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }

    @objc private func tapped(_ sender: UITapGestureRecognizer) {
        didReceiveTap?()
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }

        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.formattedPrice
        subtitleLabel.attributedText = viewModel.attributedDescription
    }

    // MARK: - Selection animation

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        compress()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        expand()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        expand()
    }

    private func compress() {
        UIView.animate(withDuration: 0.24, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.layer.transform = CATransform3DMakeScale(0.96, 0.96, 1)
        }, completion: nil)
    }

    private func expand() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }

}
