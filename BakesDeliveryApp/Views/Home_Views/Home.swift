//
//  Home.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 31/10/2024.
//

//
//  Home.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 31/10/2024.


//import SwiftUI
//
//struct Home: View {
//    @ObservedObject var HomeModel = HomeViewModel()
//   
//    var body: some View {
//        ZStack {
//            VStack(spacing: 10) {
//                HStack(spacing: 15) {
//                    Text(HomeModel.userAddress)
//                        .font(.caption)
//                        .fontWeight(.heavy)
//                        .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
//                    Spacer(minLength: 0)
//                    
//                    Text(HomeModel.userLocation == nil ? NSLocalizedString("تحديد الموقع ...", comment: "") : NSLocalizedString("تسليم إلى", comment: ""))
//                        .foregroundColor(.black)
//                    
//                    // Menu Button
//                    Button(action: { withAnimation(.easeIn) { HomeModel.showMenu.toggle() } }) {
//                        Image(systemName: "line.3.horizontal")
//                            .font(.title)
//                            .foregroundColor(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
//                    }
//                }
//                .padding([.horizontal, .top])
//                
//                Divider()
//                
//                // Search Bar
//                SearchBar(search: $HomeModel.search)
//                
//                Divider()
//                
//                // Loading or displaying items
//                if HomeModel.items.isEmpty {
//                    LoadingView()
//                } else {
//                    ScrollView(.vertical,   showsIndicators: false, content: {
//                        VStack(spacing: 25) {
//                            ForEach($HomeModel.filtered) { $item in
//                                // Item View...
//                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
//                                    ItemView(item: item, HomeModel: HomeModel)
//                                    
//                                    HStack {
//                                        Text("التوصيل مجاني")
//                                            .foregroundColor(.white)
//                                            .padding(.vertical, 10)
//                                            .padding(.horizontal)
//                                            .background(Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
//                                        
//                                        Spacer(minLength: 0)
//                                        
//                                        // Buttons (Favorite and Add to Cart)
//                                        HStack(spacing: 10) {
//                                            // Favorite Button
//                                            Spacer(minLength: 0)
//                                            FavoriteButton(item: $item)
//                                            
//                                            // Add to Cart Button
//                                            Button(action: {
//                                                HomeModel.addToCart(item: item)
//                                            }, label: {
//                                                Image(systemName: item.isAdded ? "checkmark" : "plus")
//                                                    .foregroundColor(.white)
//                                                    .padding(10)
//                                                    .background(item.isAdded ? Color.green : Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255))
//                                                    .clipShape(Circle())
//                                            })
//                                        }
//                                    }
//                                    .padding(.trailing, 10)
//                                    .padding(.top, 10)
//                                })
//                                .frame(width: UIScreen.main.bounds.width - 30)
//                            }
//                        }
//                        .padding(.top, 10)
//                    })
//                }
//            }
//            
//            // No Location Alert
//            if HomeModel.noLocation {
//                AlertView(message: "يرجى السماح بالوصول إلى الموقع في الإعدادات للمضي قدمًا !!!")
//            }
//            
//            // Side Menu
//            HStack {
//                Spacer(minLength: 0) // Push the menu to the right
//                Menu(homeData: HomeModel)
//                    .offset(x: HomeModel.showMenu ? 0 : UIScreen.main.bounds.width / 1.6) // Slide from the right
//            }
//            .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea())
//            .onTapGesture {
//                withAnimation(.easeIn) { HomeModel.showMenu.toggle() }
//            }
//        }
//        
//        .onAppear {
//            HomeModel.locationManager.delegate = HomeModel
//        }
//        .onReceive(HomeModel.$search.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)) { newValue in
//            if newValue.isEmpty {
//                withAnimation(.linear) {
//                    HomeModel.filtered = HomeModel.items
//                }
//            } else {
//                HomeModel.filterData()
//            }
//        }
//    }
//    
//}
//
//#Preview {
//    Home()
//}



import SwiftUI

struct Home: View {
    @ObservedObject var HomeModel = HomeViewModel()
    
    // MARK: - Centralized Styles
    private enum Style {
        static let primaryColor = Color(red: 255/255, green: 102/255, blue: 0/255)
        static let titleFont = Font.system(.caption, weight: .heavy)
        static let bodyFont = Font.system(.body)
        static let paddingStandard: CGFloat = 15
        static let paddingLarge: CGFloat = 25
        static let cornerRadius: CGFloat = 10
    }
    
    var body: some View {
        ZStack {
            // MARK: - Main Content
            VStack(spacing: Style.paddingStandard / 2) {
                // MARK: - Top Bar
                HStack(spacing: Style.paddingStandard) {
                    Group {
                        Text(HomeModel.userAddress)
                            .font(Style.titleFont)
                            .foregroundColor(Style.primaryColor)
                        
                        Spacer()
                        
                        Text(HomeModel.userLocation == nil ?
                             NSLocalizedString("تحديد الموقع ...", comment: "") :
                             NSLocalizedString("تسليم إلى", comment: ""))
                            .font(Style.bodyFont)
                            .foregroundColor(.black)
                        
                        // Menu Button
                        Button(action: {
                            withAnimation(.easeIn) {
                                HomeModel.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2) // More balanced size
                                .foregroundColor(Style.primaryColor)
                                .padding(8) // Better tap target
                        }
                    }
                    .padding(.horizontal, 4) // Micro-adjustment
                }
                .padding([.horizontal, .top])
                
                Divider()
                    .padding(.top, 4)
                
                // MARK: - Search Bar
                SearchBar(search: $HomeModel.search)
                    .padding(.horizontal, Style.paddingStandard)
                
                Divider()
                    .padding(.bottom, 4)
                
                // MARK: - Items List
                if HomeModel.items.isEmpty {
                    LoadingView()
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: Style.paddingStandard) {
                            ForEach($HomeModel.filtered) { $item in
                                // MARK: - Item Card
                                ZStack(alignment: .top) {
                                    ItemView(item: item, HomeModel: HomeModel)
                                    
                                    HStack {
                                        Text("التوصيل مجاني")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(Style.primaryColor)
                                            .cornerRadius(Style.cornerRadius)
                                        
                                        Spacer()
                                        
                                        // MARK: - Action Buttons
                                        HStack(spacing: 8) {
                                            FavoriteButton(item: $item)
                                            
                                            Button(action: {
                                                HomeModel.addToCart(item: item)
                                            }) {
                                                Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                                    .background(
                                                        item.isAdded ? Color.green : Style.primaryColor
                                                    )
                                                    .clipShape(Circle())
                                                    .shadow(radius: 2) // Depth effect
                                            }
                                        }
                                    }
                                    .padding(Style.paddingStandard)
                                }
                                .frame(width: UIScreen.main.bounds.width - 30)
                                .background(Color.white)
                                .cornerRadius(Style.cornerRadius)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.vertical, Style.paddingStandard)
                    }
                }
            }
            
            // MARK: - Location Alert
            if HomeModel.noLocation {
                AlertView(message: "يرجى السماح بالوصول إلى الموقع في الإعدادات للمضي قدمًا !!!")
            }
            
            // MARK: - Side Menu
            HStack {
                Spacer()
                Menu(homeData: HomeModel)
                    .offset(x: HomeModel.showMenu ? 0 : UIScreen.main.bounds.width / 1.6)
                    .transition(.move(edge: .trailing))
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            HomeModel.showMenu.toggle()
                        }
                    }
            )
        }
        .onAppear {
            HomeModel.locationManager.delegate = HomeModel
        }
    }
}

// MARK: - Preview
#Preview {
    Home()
}
