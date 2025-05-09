//
//  TaskRepository.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 06/10/2024.
//

import SwiftUI
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    let db = Firestore.firestore()
    @Published var locationManager = CLLocationManager()
    
    // Data
    @Published var items = [Item]()
    @Published var filtered = [Item]()
    @Published var cartItems: [Cart] = []
    @Published var userOrders: [UserOrder] = []
    
    // Location
    @Published var userLocation: CLLocation?
    @Published var userAddress = ""
    @Published var noLocation = false
    
    // UI State
    @Published var showMenu = false
    @Published var search = ""
    @Published var ordered = false
    
    // MARK: - Location Management
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Location authorized")
            manager.requestLocation()
            self.noLocation = false
            self.userAddress = NSLocalizedString("جاري تحديد الموقع...", comment: "")
        case .denied:
            print("Location denied")
            self.noLocation = true
            self.userAddress = NSLocalizedString("الوصول إلى الموقع غير مسموح", comment: "")
        default:
            print("Requesting location access")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.userLocation = newLocation
        
        print("User Location: \(self.userLocation?.coordinate.latitude ?? 0), \(self.userLocation?.coordinate.longitude ?? 0)")
        
        // Get Arabic address first
        self.extractArabicLocation { [weak self] in
            guard let self = self else { return }
            self.saveLocationToFirebase()
            self.fetchData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        self.userAddress = NSLocalizedString("خطأ في تحديد الموقع", comment: "")
    }
    
    
    
    // MARK: - Arabic Address Handling for Libya
    private func extractArabicLocation(completion: @escaping () -> Void) {
        guard let location = self.userLocation else {
            completion()
            return
        }
        
        let geocoder = CLGeocoder()
        let arabicLocale = Locale(identifier: "ar_LY")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: arabicLocale) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.userAddress = NSLocalizedString("فشل تحميل العنوان", comment: "")
                    completion()
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    self.userAddress = NSLocalizedString("عنوان غير معروف", comment: "")
                    completion()
                    return
                }
                
                var arabicComponents: [String] = []
                
                if let thoroughfare = placemark.thoroughfare {
                    arabicComponents.append(self.translateToArabic(self.convertNumbersToArabic(thoroughfare)))
                }
                
                if let subLocality = placemark.subLocality {
                    arabicComponents.append(self.translateToArabic(subLocality))
                }
                
                if let locality = placemark.locality {
                    arabicComponents.append(self.translateToArabic(locality))
                }
                
                if let country = placemark.country {
                    arabicComponents.append(self.localizeCountryName(country))
                }
                
                self.userAddress = arabicComponents.joined(separator: "، ")
                completion()
            }
        }
    }

    // Convert English digits in street names to Arabic digits
    private func convertNumbersToArabic(_ text: String) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ar")

        return text.map { char in
            if char.isNumber, let number = Int(String(char)),
               let arabicNumber = formatter.string(from: NSNumber(value: number)) {
                return arabicNumber
            }
            return String(char)
        }.joined()
    }

    private func translateToArabic(_ text: String) -> String {
        let translations = [
            "Street": "شارع",
            "Avenue": "طريق",
            "Road": "طريق",
            "Boulevard": "جادة",
            "Square": "ميدان",
            "Libya": "ليبيا",
            // Add more translations as needed
        ]
        
        var translatedText = text
        for (english, arabic) in translations {
            translatedText = translatedText.replacingOccurrences(of: english, with: arabic)
        }
        return translatedText
    }

    // Localize country names — tailored for Libya only
    private func localizeCountryName(_ country: String) -> String {
        let translations = [
            "Libya": "ليبيا",
            "Libyan Arab Jamahiriya": "ليبيا"  // Older iOS names
        ]
        return translations[country] ?? country
    }


    // MARK: - Firebase Integration
    func saveLocationToFirebase() {
        guard let userLocation = self.userLocation,
              let userId = Auth.auth().currentUser?.uid else {
            print("Location or user not available")
            return
        }
        
        db.collection("users").document(userId).setData([
            "user_id": userId,
            "location": GeoPoint(
                latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude
            ),
            "last_updated": FieldValue.serverTimestamp()
        ], merge: true) { error in
            if let error = error {
                print("Firebase save error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Data Management (Existing functions remain identical)
    
    func fetchData() {
            db.collection("Items").addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching items: \(error.localizedDescription)")
                    return
                }
    
                guard let querySnapshot = querySnapshot else {
                    print("Error: Query snapshot is nil")
                    return
                }
    
                self.items = querySnapshot.documents.compactMap { document in
                    // Safely retrieve fields
                    let itemName = document["item_name"] as? String ?? "Unknown"
                    let itemDetails = document["item_description"] as? String ?? "No description"
                    let itemCost = document["item_cost"] as? Double ?? 0.0
                    let itemRatings = document["Item_ratings"] as? String ?? "0.0"
                    let itemImage = document["item_image"] as? String ?? ""
    
                    // Return an Item instance
                    return Item(
                        id: document.documentID,
                        item_name: itemName,
                        item_description: itemDetails,
                        item_cost: itemCost,
                        Item_ratings: itemRatings,
                        item_image: itemImage,
                        isAdded: false,
                        isFavorite: false,
                        quantity: 0 // Default value
                    )
                }
    
                // Update the filtered items array
                self.filtered = self.items
            }
        }
       //Search or Filter
        func filterData(){
    
            withAnimation(.linear){
                self.filtered = self.items.filter{return $0.item_name.lowercased().contains(self.search.lowercased())
    
                }
            }
        }
    
        // add to Cart Function ...
        func addToCart(item: Item) {
            guard (Auth.auth().currentUser?.uid) != nil else {
                print("Error: User not authenticated")
                return
            }
            // Get the index of the item in the `items` array
            let itemIndex = getIndex(item: item, isCartIndex: false)
    
            // Toggle the `isAdded` property
            self.items[itemIndex].isAdded.toggle()
    
            // Update the `filtered` array
            if let filterIndex = self.filtered.firstIndex(where: { $0.id == item.id }) {
                self.filtered[filterIndex].isAdded = self.items[itemIndex].isAdded
            }
    
            if self.items[itemIndex].isAdded {
                // Add to cart
                self.cartItems.append(Cart(item: item, quantity: 1))
            } else {
                // Remove from cart if it exists
                if let cartIndex = cartItems.firstIndex(where: { $0.item.id == item.id }) {
                    self.cartItems.remove(at: cartIndex)
                }
            }
        }
        func resetCart() {
            // Reset cart items
            cartItems.removeAll()
    
            // Reset the isAdded flag in all items and filtered items
            for index in items.indices {
                items[index].isAdded = false
            }
            for index in filtered.indices {
                filtered[index].isAdded = false
            }
        }
    
        func getIndex(item:Item, isCartIndex:Bool)->Int{
    
            let index = self.items.firstIndex{(item1)->Bool in
                return item.id == item1.id } ?? 0
    
            let cartIndex = self.cartItems.firstIndex{(item1)->Bool in
                return item.id == item1.item.id } ?? 0
    
            return isCartIndex ? cartIndex : index
    
    
        }
    
    
        func calculateTotalPrice() -> String {
            var price: Float = 0
    
            for item in cartItems {
                let quantity = item.quantity
                let cost = Float(item.item.item_cost)
                print("Item: \(item.item.item_name), Quantity: \(quantity), Cost: \(cost)")
    
                price += Float(quantity) * cost
            }
    
            print("Total price before formatting: \(price)")
            return getPrice(value: price)
        }
    
        func getPrice(value: Float)->String{
            let format = NumberFormatter()
            format.numberStyle = .currency
            format.currencyCode = "LYD"
            format.currencySymbol = "ل.د"
            return("\(String(format: "%.2f", value)) ل.د")
            //return "\u{200F}ل.د \(String(format: "%.2f", value))"
           // return "ل.د \(String(format: "%.2f", value))"
    
        }
    
    
        // Toggle favorite status
        func toggleFavorite(for item: Item) {
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index].isFavorite.toggle()
                print("Updated items array: \(items.map { "\(String(describing: $0.id)): \($0.isFavorite)" })")
            } else {
                print("Item not found for id: \(String(describing: item.id))")
            }
        }
    
    
            // Save favorite status to Firestore
        private func saveFavoriteStatus(for item: Item) {
            guard let user_id = Auth.auth().currentUser?.uid else {
                print("Error: User not authenticated")
                return
            }
    
            guard let itemId = item.id else {
                print("Error: Item ID is nil. Cannot update favorite status.")
                return
            }
    
            let userDoc = db.collection("users").document(user_id)
    
            if item.isFavorite {
                userDoc.updateData([
                    "favorite_items": FieldValue.arrayUnion([itemId])
                ]) { error in
                    if let error = error {
                        print("Error adding favorite: \(error)")
                    }
                }
            } else {
                userDoc.updateData([
                    "favorite_items": FieldValue.arrayRemove([itemId])
                ]) { error in
                    if let error = error {
                        print("Error removing favorite: \(error)")
                    }
                }
            }
        }
    
        func fetchAllOrders() {
            let db = Firestore.firestore()
            db.collection("User_Orders").order(by: "Order_Date", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching orders: \(error.localizedDescription)")
                    return
                }
    
                guard let documents = snapshot?.documents else { return }
    
                self.userOrders = documents.compactMap { document in
                    let data = document.data()
    
                    // Safely unwrap all required fields
                    guard let customerNote = data["Customer_Note"] as? String,
                          let deliveryDatesTimestamps = data["Delivery_Dates"] as? [Timestamp],
                          let orderDateTimestamp = data["Order_Date"] as? Timestamp,
                          let orderItemsData = data["Order_Items"] as? [[String: Any]],
                          let totalCost = data["Total_Cost"] as? Double,
                          let userId = data["user_id"] as? String else {
                        return nil
                    }
    
                    // Map delivery dates
                    let deliveryDates = deliveryDatesTimestamps.map { $0.dateValue() }
    
                    // Map order items
                    let orderItems = orderItemsData.compactMap { itemData -> OrderItem? in
                        guard let itemName = itemData["item_name"] as? String,
                              let quantity = itemData["quantity"] as? Int,
                              let cost = itemData["cost"] as? Double else {
                            return nil
                        }
                        return OrderItem(itemName: itemName, quantity: quantity, cost: cost)
                    }
    
                    // Return a valid UserOrder
                    return UserOrder(
                        id: document.documentID,
                        customerNote: customerNote,
                        deliveryDates: deliveryDates,
                        orderDate: orderDateTimestamp.dateValue(),
                        orderItems: orderItems,
                        totalCost: totalCost,
                        userId: userId
                    )
                }
            }
        }
    
    
    
    
    
    // MARK: - Computed Properties
    var totalCost: Double {
        items.filter { $0.isAdded }
            .reduce(0.0) { $0 + ($1.item_cost * Double($1.quantity)) }
    }
}


