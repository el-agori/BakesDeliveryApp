//
//  MyOrdersView.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 01/12/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MyOrdersView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present

    var body: some View {
        VStack {
            
            HStack(spacing: 20) {
                
                Button(action: { present.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                }
                Spacer()

            }
            .padding()

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    if homeData.userOrders.isEmpty {
                        Text("لم يتم العثور على أي طلبات")
                            .font(.headline)
                            .padding(.top, 20)
                    } else {
                        ForEach(homeData.userOrders) { order in
                            let totalCost = calculateTotalCost(for: order)
                            OrderItemView(order: order)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            homeData.fetchAllOrders()
        }
        
    }

    // Updated calculateTotalCost function
    func calculateTotalCost(for order: UserOrder) -> String {
        let total = order.orderItems.reduce(0) { sum, item in
            sum + item.cost * Double(item.quantity)
        }
        return "ل.د\(String(format: "%.2f", total))"
        
    }
}



