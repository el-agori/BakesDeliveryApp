//
//  AuthManager.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 19/12/2024.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    /// Starts phone number authentication.
    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error starting auth: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let verificationID = verificationID {
                // Save verification ID for later use
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Verifies the SMS code.
    func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("Verification ID not found.")
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Error verifying code: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if authResult != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
