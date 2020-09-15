//
//  OrderHistoryItemView.swift
//  Milkshakr
//
//  Created by Guilherme Rambo on 15/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import SwiftUI
import MilkshakrKit

struct OrderHistoryItemView: View {
    let purchase: Purchase
    var body: some View {
        VStack(alignment: .leading) {
            Text(purchase.formattedDate)
                .padding(.bottom, 16)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(Color(UIColor.secondaryText))
            ForEach(purchase.items) { item in
                HStack(spacing: 6) {
                    Text(item.title)
                    if item.quantity > 1 {
                        Text(" × \(item.quantity)")
                            .foregroundColor(Color(UIColor.secondaryText))
                    }
                    Spacer()
                    Text(item.linePrice.formatted)
                }
                Divider()
            }
            HStack(spacing: 6) {
                Text("Total")
                Spacer()
                Text(purchase.total.formatted)
            }.font(.system(size: 18, weight: .medium, design: .rounded))
        }
        .padding()
        .background(Color(.background))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.14), radius: 16, x: 0, y: 0)
    }
}

struct OrderHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryItemView(purchase: .preview)
            .padding(60)
            .previewLayout(.sizeThatFits)
    }
}

fileprivate extension Purchase {
    static let preview: Purchase = {
        var p = Purchase()
        p.add(Bundle.milkshakrKit.loadDemoProducts()[0], quantity: 1)
        p.add(Bundle.milkshakrKit.loadDemoProducts()[1], quantity: 2)
        return p
    }()
}

fileprivate extension Decimal {
    static let formatter: NumberFormatter = {
        let f = NumberFormatter()

        f.numberStyle = .currency

        return f
    }()

    var formatted: String {
        Self.formatter.string(from: NSDecimalNumber(decimal: self)) ?? "ERROR"
    }
}

fileprivate extension Purchase {
    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()

        f.dateStyle = .medium
        f.timeStyle = .short

        return f
    }()

    var formattedDate: String {
        Self.dateFormatter.string(from: createdAt)
    }
}
