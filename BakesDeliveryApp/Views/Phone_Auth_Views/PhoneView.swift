//
//  PhoneView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 19/12/2024.
//
import SwiftUI
import FirebaseAuth
import Firebase

private enum AppStyle {
    static let titleFont = Font.system(.largeTitle, weight: .bold)
    static let bodyFont = Font.system(.body)
    static let primaryColor = Color.orange
    static let textOnPrimary = Color.white
    static let standardPadding: CGFloat = 16
}

struct AuthView1: View {
    var body: some View {
        NavigationView {
            PhoneView()
        }
    }
}
struct PhoneView: View {
    @State private var phoneNumber: String = ""
    @State private var userName: String = ""
    @State private var navigateToSMSCodeView: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                // Title
                Text("مرحباً")
                    .font(AppStyle.titleFont) // Consistent title
                        .padding(.bottom, AppStyle.standardPadding)
                
                Text("أدخل رقم هاتفك لتسجيل الدخول")
                    .foregroundColor(.gray)
                
                // User Name Input
                TextField("الاسم", text: $userName)
                    .padding()
                    .multilineTextAlignment(.trailing)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .overlay(HStack {
                        Spacer()
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .padding(.trailing, 30)
                    })
                
                // Phone Number Input
                TextField("رقم الهاتف", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .overlay(HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.gray)
                            .padding(.leading, 40)
                        Spacer()
                    })
                    .onChange(of: phoneNumber) { newValue in
                        // Basic phone number formatting
                        phoneNumber = newValue.filter { $0.isNumber }
                    }
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Continue Button
                Button(action: handleContinue) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("استمرار")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .disabled(isLoading || phoneNumber.isEmpty || userName.isEmpty)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToSMSCodeView) {
                SMSCodeView(phoneNumber: formatPhoneNumber(phoneNumber), userName: userName)
            }
        }
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        // Ensure proper international format
        if number.hasPrefix("+") {
            return number
        } else {
            return "+1\(number)" // Default to +1 if no country code
        }
    }
    
    private func handleContinue() {
        guard !userName.isEmpty else {
            errorMessage = "الرجاء إدخال اسمك"
            return
        }
        
        guard !phoneNumber.isEmpty else {
            errorMessage = "الرجاء إدخال رقم هاتفك"
            return
        }
        
        // Additional phone number validation
        guard phoneNumber.count >= 10 else {
            errorMessage = "يجب أن يتكون رقم الهاتف من 10 أرقام على الأقل"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let formattedNumber = formatPhoneNumber(phoneNumber)
        
        AuthManager.shared.startAuth(phoneNumber: formattedNumber) { success in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    saveUserToFirestore()
                    navigateToSMSCodeView = true
                } else {
                    errorMessage = "فشل بدء المصادقة. يرجى المحاولة مرة أخرى."
                }
            }
        }
    }
    
    private func saveUserToFirestore() {
        let userId = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let formattedNumber = formatPhoneNumber(phoneNumber)
        let userDocument: [String: Any] = [
            "user_id": userId,
            "name": userName,
            "phone_number": formattedNumber,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        Firestore.firestore().collection("users").document(userId).setData(userDocument) { error in
            if let error = error {
                print("خطأ في حفظ المستخدم: \(error.localizedDescription)")
            } else {
                print("تم حفظ المستخدم بنجاح")
            }
        }
    }
}



struct AuthView1_Previews: PreviewProvider {
    static var previews: some View {
        AuthView1()
    }
}


