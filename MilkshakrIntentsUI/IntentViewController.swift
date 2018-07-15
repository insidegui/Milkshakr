//
//  IntentViewController.swift
//  MilkshakrIntentsUI
//
//  Created by Guilherme Rambo on 15/07/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import IntentsUI
import MilkshakrKit
import os.log

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {

    private let log = OSLog(subsystem: "MilkshakrIntents", category: "IntentViewController")

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        os_log("UI extension view did load", log: log, type: .info)
    }

    private let store = ProductStore()
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        guard let intent = interaction.intent as? OrderMilkshakeIntent else {
            os_log("Intent was not an OrderMilkshakeIntent. WHAT?!", log: self.log, type: .fault)
            completion(false, parameters, self.desiredSize)
            return
        }

        guard let productIdentifier = intent.product?.identifier else {
            os_log("Intent didn't have a product identifier. WHAT?!", log: self.log, type: .fault)
            completion(false, parameters, self.desiredSize)
            return
        }

        os_log("Fetching product with identifier %{public}@", log: log, type: .info, productIdentifier)

        store.fetch(with: productIdentifier) { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .success(let product):
                os_log("Fetched \"%{public}@\", preparing views", log: self.log, type: .info, product.name)

                self.configure(with: product)

                completion(true, parameters, self.desiredSize)
            case .error(let error):
                os_log("Failed to fetch product: %{public}@", log: self.log, type: .error, String(describing: error))

                completion(false, parameters, self.desiredSize)
            }
        }


    }

    private func configure(with product: Product) {
        let viewModel = ProductViewModel(product: product)

        imageView?.image = viewModel.image
        titleLabel?.text = viewModel.title
        priceLabel?.text = viewModel.formattedPrice
    }
    
    var desiredSize: CGSize {
        let maxSize = self.extensionContext!.hostedViewMaximumAllowedSize

        return CGSize(width: maxSize.width, height: 234)
    }
    
}
