//
//  Menu.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 31/10/2024.
//


import SwiftUI

struct Menu: View {
    @ObservedObject var homeData: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Top Spacer to align with search box
            Spacer()
                .frame(height: 80) // Adjust height as needed to align with search box

            // Cart Option
            NavigationLink(destination: CartView(homeData: homeData)) {
                HStack(spacing: 15) {
                    Spacer()
                    Text("عربة التسوق")
                
                        .multilineTextAlignment(.leading)
                       // .fontWeight(.bold)
                        .foregroundColor(.black)
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                        .environment(\.layoutDirection, .rightToLeft)
                        
                        
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

            // My Orders Option
            NavigationLink(destination: MyOrdersView(homeData: homeData)) {
                HStack(spacing: 15) {
                    
                    Spacer()
                    Text("طلبياتي")
                       // .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Image(systemName: "scroll")
                        .font(.title)
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                   
                   
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

            // My Addresses Option
            NavigationLink(destination: MyAddressesView()) {
                HStack(spacing: 15) {
                    Spacer()
                    Text("عناويني")
                        //.fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Image(systemName: "house")
                        .font(.title)
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                    
                }
                .padding()
            }

            // User Account and Settings Option
            NavigationLink(destination: ProfileView()) {
                HStack(spacing: 15) {
                    Spacer()
                    Text("الحساب والإعدادات")
                        //.fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Image(systemName: "person.crop.circle")
                        .font(.title)
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                    
                }
                .padding()
            }

            
            // Call Customer Service Option
            Button(action: {
                if TARGET_OS_SIMULATOR != 0 {
                    if let url = URL(string: "https://example.com") {
                        UIApplication.shared.open(url) { success in
                            if !success {
                                print("Failed to open URL")
                            }
                        }
                    }
                } else {
                    if let phoneUrl = URL(string: "tel://1234567890") {
                        UIApplication.shared.open(phoneUrl) { success in
                            if !success {
                                print("Failed to open phone URL")
                            }
                        }
                    }
                }
            }) {
                HStack(spacing: 15) {
                    Spacer()
                    Text("خدمة العملاء")
                      //  .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Image(systemName: "headphones")
                        .font(.title)
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                    
                }
                .padding()
            }

            Spacer() // Keep some space at the bottom

           
        }
        .padding([.top, .trailing], 20) // Adjusted padding for overall spacing
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}


