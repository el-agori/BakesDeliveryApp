//
//  ProfileView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 15/01/2025.
//


import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var isLoggedOut: Bool = false
    @State private var userName: String = "...تحميل"
    @State private var userPhone: String = "...تحميل"
    @State private var userInitials: String = "MJ" // Default initials
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Custom Header Section
            HStack(spacing: 20) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                }

                Spacer()
            }
            .padding()

            // Content Section
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    // Profile Header
                    HStack {
                        Text(userInitials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72, alignment: .center)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text(userPhone)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // General Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("عام")
                            .font(.headline)
                            .foregroundColor(.black)
                        HStack {
                            SettingsRowView(imageName: "gear", title: "الإصدار", tintColor: Color(.systemGray))
                            Spacer()
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Divider()
                    }
                    .padding(.horizontal)
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("الحساب")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Button {
                            handleSignOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "تسجيل الخروج", tintColor: .red)
                        }
                        Divider()
                        
                        Button {
                            print("حذف الحساب")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "حذف الحساب", tintColor: .red)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true) // Hides the default navigation bar
        .navigationBarBackButtonHidden(true) // Removes the blue back button
        .onAppear {
            fetchUserProfile()
        }
        .environment(\.layoutDirection, .rightToLeft) 
    }
    
    private func fetchUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("لم يتم تسجيل دخول أي مستخدم")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("User document is empty.")
                return
            }
            
            self.userName = data["name"] as? String ?? "No Name"
            self.userPhone = data["phone_number"] as? String ?? "No Phone"
            if let name = data["name"] as? String {
                self.userInitials = name.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
            }
        }
    }
    
    private func handleSignOut() {
        do {
            try Auth.auth().signOut() // Sign out the user
            print("User signed out successfully")
            isLoggedOut = true // Trigger navigation to PhoneView
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

#Preview {
    ProfileView()
}

