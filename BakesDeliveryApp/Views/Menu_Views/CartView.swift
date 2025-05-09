//
//  CartView.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 13/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    @State private var showCalendarView = false

    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack {
                    // Back Button
                    Button(action: { present.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                    }


                    Spacer()

                    // Cancel Button (X)
                    Button(action: {
                        homeData.resetCart() // Reset cart and isAdded state
                        present.wrappedValue.dismiss() // Go back to the previous screen
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                // Cart Items List or Empty Cart Message
                if homeData.cartItems.isEmpty {
                    VStack {
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.gray.opacity(0.5))

                        Text("سلة التسوق الخاصة بك فارغة")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray.opacity(0.7))
                            .padding(.top, 10)

                        Text("ابدأ بإضافة العناصر إلى سلة التسوق الخاصة بك")
                            .font(.body)
                            .foregroundColor(Color.gray)
                            .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(homeData.cartItems) { cart in
                                HStack(spacing: 15) {
                                    WebImage(url: URL(string: cart.item.item_image))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 130, height: 130)
                                        .cornerRadius(15)

                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(cart.item.item_name)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .lineLimit(1) // Force single line
                                            .truncationMode(.tail)
                                        Text(cart.item.item_description)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .lineLimit(2)
                                            .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        HStack(spacing: 15) {
                                            Text(homeData.getPrice(value: Float(cart.item.item_cost)))
                                                .font(.title3)
                                                .fontWeight(.heavy)
                                                .foregroundColor(.black)
                                            Spacer()

                                            // Quantity Controls
                                            Button(action: {
                                                let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                                if cart.quantity > 1 {
                                                    homeData.cartItems[index].quantity -= 1
                                                    
                                                }else{
                                                    homeData.cartItems.remove(at: index)
                                                    if let itemIndex = homeData.items.firstIndex(where: { $0.id == cart.item.id }) {
                                                                homeData.items[itemIndex].isAdded = false
                                                            }
                                                            
                                                            // Optional: also update `filtered` if you're showing filtered results
                                                            if let filteredIndex = homeData.filtered.firstIndex(where: { $0.id == cart.item.id }) {
                                                                homeData.filtered[filteredIndex].isAdded = false
                                                            }
                                                }
                                            }) {
                                                Image(systemName: "minus")
                                                    .font(.system(size: 16, weight: .heavy))
                                                    .foregroundColor(.black)
                                            }

                                            Text("\(cart.quantity)")
                                                .fontWeight(.heavy)
                                                .foregroundColor(.black)
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 10)
                                                .background(Color.black.opacity(0.06))

                                            Button(action: {
                                                homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                            }) {
                                                Image(systemName: "plus")
                                                    .font(.system(size: 16, weight: .heavy))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width - 30)
                                .padding()
                                .contextMenu {
                                    Button(action: {
                                        let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                        let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                        homeData.items[itemIndex].isAdded = false
                                        homeData.filtered[itemIndex].isAdded = false
                                        homeData.cartItems.remove(at: index)
                                    }) {
                                        Text("حذف")
                                    }
                                }
                            }
                        }
                    }
                }

                // Bottom Summary and Checkout
                
               
                if !homeData.cartItems.isEmpty {
                    VStack {
                        HStack {
                            Text("المجموع")
                                .font(.subheadline)
                               // .fontWeight(.heavy)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(homeData.calculateTotalPrice())
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                        }
                        .padding([.top, .horizontal])

                        Button(action: {
                            if !homeData.cartItems.isEmpty {
                                showCalendarView = true
                            } else {
                                print("عربة التسوق فارغة. لا يمكن المتابعة إلى عملية الدفع.")
                            }
                        }) {
                            Text("الدفع")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
                                .cornerRadius(15)
                        }
                        .padding()
                    }
                    .background(Color.white)
                }
            }
            .navigationDestination(isPresented: $showCalendarView) {
                CalendarView(homeData: homeData)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .environment(\.layoutDirection, .rightToLeft)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}




