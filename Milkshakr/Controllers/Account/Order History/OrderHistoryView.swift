//
//  OrderHistoryView.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 15/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import SwiftUI
import MilkshakrKit

struct OrderHistoryView: View {
    @EnvironmentObject var store: AccountStore
    
    var body: some View {
        if store.purchases.isEmpty {
            Text("It looks like you haven't made any purchases yet.\n\nCheck out the great products we have to offer, and don't forget to enjoy and have fun!")
                .foregroundColor(Color(.secondaryText))
                .multilineTextAlignment(.center)
                .padding()
        } else {
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(store.purchases) { purchase in
                        OrderHistoryItemView(purchase: purchase)
                    }
                }.padding()
            }
        }

    }
}

#if DEBUG
struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
            .environmentObject(AccountStore.preview())

        OrderHistoryView()
            .environmentObject(AccountStore.preview(empty: true))
    }
}

fileprivate extension AccountStore {
    static func preview(empty: Bool = false) -> AccountStore {
        let store = AccountStore()

        if !empty {
            let products = Bundle.milkshakrKit.loadDemoProducts()
            var p1 = Purchase()
            p1.add(products[0], quantity: 1)
            p1.add(products[1], quantity: 2)

            var p2 = Purchase()
            p2.add(products[2], quantity: 3)
            p2.add(products[3], quantity: 1)
            p2.add(products[4], quantity: 1)

            store.preview_setPurchaseHistory([p1, p2])
        }

        return store
    }
}
#endif
