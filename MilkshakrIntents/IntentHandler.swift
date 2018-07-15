//
//  IntentHandler.swift
//  MilkshakrIntents
//
//  Created by Guilherme Rambo on 15/07/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Intents
import MilkshakrKit

class IntentHandler: INExtension, OrderMilkshakeIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }

    func handle(intent: OrderMilkshakeIntent, completion: @escaping (OrderMilkshakeIntentResponse) -> Void) {
        let response = OrderMilkshakeIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
    
}
