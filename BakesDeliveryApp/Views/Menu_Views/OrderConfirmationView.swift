//
//  OrderConfirmationView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 11/01/2025.
//

import SwiftUI

struct OrderConfirmationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.green)

            Text("تم تأكيد الطلب")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("نشكرك على طلبك. سوف تتلقى رسالة تأكيد بالبريد الإلكتروني قريبًا.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                // Navigate to Home or MyOrdersView
            }) {
                Text("العودة إلى الصفحة الرئيسية")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
