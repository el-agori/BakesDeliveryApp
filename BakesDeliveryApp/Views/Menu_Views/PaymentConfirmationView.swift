//
//  PaymentConfirmationView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 08/01/2025.
//

import SwiftUI

struct PaymentConfirmationView: View {
    var body: some View {
        VStack {
            Text("تأكيد الدفع")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("لقد تم حفظ طلبك بنجاح. يرجى المتابعة إلى الدفع")
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button(action: {
                // Handle Payment
                print("بدأت عملية الدفع")
            }) {
                Text("قم بالدفع")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
        }
        .environment(\.layoutDirection, .rightToLeft)
        .padding()
    }
}

#Preview {
    PaymentConfirmationView()
}
