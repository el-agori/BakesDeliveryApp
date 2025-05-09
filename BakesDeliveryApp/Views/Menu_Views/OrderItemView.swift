//
//  OrderItemView.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 04/12/2024.
//

import SwiftUI


struct OrderItemView: View {
    let order: UserOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("رقم الطلب: \(order.id)")
                .font(.headline)
                .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
            Text("التاريخ: \(formattedDate(order.orderDate))")
                .font(.subheadline)
                .foregroundColor(.gray)

            ForEach(order.orderItems) { item in
                HStack {
                    Text(item.itemName)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()

                    Text("الكمية: \(item.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("\(String(format: "%.2f", item.cost)) ل.د")

                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }

            HStack {
                Spacer()
                Text("المجموع: ل.د\(String(format: "%.2f", order.totalCost))")
              //  Text("المجموع: \(String(format: "%.2f", order.totalCost)) ل.د")

                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}



