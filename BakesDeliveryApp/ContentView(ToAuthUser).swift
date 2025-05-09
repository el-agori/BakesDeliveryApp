//
//  ContentView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 18/12/2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                AccountView() // Show AccountView if authenticated
            } else {
                PhoneView() // Show PhoneView if not authenticated
            }
        }
        .onAppear {
            checkAuthentication() // Check if user is authenticated
        }
    }
    
    private func checkAuthentication() {
        // Check if the user is already authenticated
        isAuthenticated = Auth.auth().currentUser != nil
    }
}
