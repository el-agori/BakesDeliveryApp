//
//  MyAddressesView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 02/01/2025.




import SwiftUI

struct MyAddressesView: View {
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack {
            // Header Section
            HStack(spacing: 20) {
                Button(action: { present.wrappedValue.dismiss() }) {
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
                    
                    Text("لم يتم العثور على أي عناوين")
                       
                        .font(.headline)
                        .padding(.top, 250)
                        .foregroundColor(.gray)
                        
                    
                }
                
                .padding()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    MyAddressesView()
}


