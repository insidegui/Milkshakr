//
//  IntentHandler.swift
//  MilkshakrIntents
//
//  Created by Guilherme Rambo on 15/07/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Intents
import MilkshakrKit
import PassKit
import os.log

class IntentHandler: INExtension, OrderMilkshakeIntentHandling {

    private let log = OSLog(subsystem: "MilkshakrIntents", category: "IntentHandler")

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }

    private var completionHandler: ((OrderMilkshakeIntentResponse) -> Void)?

    private let store = ProductStore()

    private let errorResponse = OrderMilkshakeIntentResponse(code: .failure, userActivity: nil)

    func handle(intent: OrderMilkshakeIntent, completion: @escaping (OrderMilkshakeIntentResponse) -> Void) {
        guard let productIdentifier = intent.product?.identifier else {
            os_log("Intent didn't have a product identifier. WHAT?!", log: self.log, type: .fault)
            completion(errorResponse)
            return
        }

        completionHandler = completion

        os_log("Fetching product with identifier %{public}@", log: log, type: .info, productIdentifier)

        store.fetch(with: productIdentifier) { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .success(let product):
                os_log("Fetched \"%{public}@\", preparing views", log: self.log, type: .info, product.name)

                self.performPassKitPayment(with: product)
            case .error(let error):
                os_log("Failed to fetch product: %{public}@", log: self.log, type: .error, String(describing: error))

                completion(self.errorResponse)
            }
        }
    }

    private var purchasedProduct: Product?

    private func performPassKitPayment(with product: Product) {
        os_log("performPassKitPayment", log: self.log, type: .info)

        purchasedProduct = product

        var purchase = Purchase()
        purchase.add(product, quantity: 1)

        let request = PKPaymentRequest(with: purchase)

        os_log("Generated payment request, presenting payment controller", log: self.log, type: .info)

        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = self

        controller.present(completion: nil)
    }

    private var paymentSuccessfull = false
    
}

extension IntentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        os_log("Payment authorized", log: self.log, type: .info)

        paymentSuccessfull = true

        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        os_log("Payment controller finished. Authorized = %{public}@",
               log: log,
               type: .info,
               String(describing: paymentSuccessfull))

        let viewModel = ProductViewModel(product: purchasedProduct!)

        let code: OrderMilkshakeIntentResponseCode = paymentSuccessfull ? .success : .failureRequiringAppLaunch

        let response = OrderMilkshakeIntentResponse(code: code, userActivity: viewModel.userActivity)
        response.product = INObject(identifier: purchasedProduct!.id, display: purchasedProduct!.name)

        controller.dismiss { [weak self] in
            guard let `self` = self else { return }

            os_log("Payment controller dismissed", log: self.log, type: .info)

            self.completionHandler?(response)
        }
    }

}
