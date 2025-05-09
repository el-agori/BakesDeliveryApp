//
//  SMSCodeView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 19/12/2024.
//
import SwiftUI
import FirebaseAuth

struct SMSCodeView: View {
    
    @State private var smsCode: String = ""  // Stores the entered SMS code
    @State private var showAccountView: Bool = false  // Determines if AccountView should be shown
    @Environment(\.presentationMode) var presentationMode  // Used to navigate back if needed
    
    var phoneNumber: String  // Pass the authenticated phone number to this view
    let userName: String

    var body: some View {
        VStack(spacing: 20) {
            Text("أدخل الرمز لتسجيل الدخول")
                .foregroundColor(.gray)
            
            TextField("أدخل الرمز", text: $smsCode)
           // TextField("Enter Code", text: $smsCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)

            Button("التحقق من الرمز") {
                AuthManager.shared.verifyCode(smsCode: smsCode) { success in
                    if success {
                        // Call FirestoreManager to store the phone number
                        FirestoreManager.shared.storePhoneNumber(phoneNumber: phoneNumber, userName: userName) { success, error in
                            if success {
                                print("تم حفظ رقم الهاتف بنجاح!")
                                // Show the AccountView
                                showAccountView = true
                            } else {
                                print("Failed to save phone number: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    } else {
                        print("Failed to verify SMS code")
                    }
                }
                
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $showAccountView) {
            AccountView()
        }
        .navigationTitle("Enter Code")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SMSCodeView(phoneNumber: "hi", userName: "hi")
}
