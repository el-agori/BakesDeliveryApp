//
//  CalendarView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 08/01/2025.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CalendarView: View {
    @FocusState private var isNoteFocused: Bool
    @ObservedObject var homeData: HomeViewModel // Access orders and total cost
    @State private var selectedDates: [Date] = [] // Stores multiple delivery dates
    @State private var note = "" // Optional note from customer
    @State private var navigateToConfirmation = false // Navigation trigger
    
    // Firestore reference
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Title
                    Text("حدد تواريخ التسليم")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)

                    // Calendar DatePicker
                    MultiDatePicker(selectedDates: $selectedDates)
                        .frame(maxHeight: 300)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray6))
                        )

                    // Order Summary Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ملخص الطلب")
                            .font(.headline)

                        ScrollView {
                            ForEach(Array(zip(homeData.items.indices, homeData.items)).filter { $0.1.isAdded }, id: \.0) { index, item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.item_name)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Text("الكمية: \(item.quantity)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("ل.د\(item.item_cost * Double(item.quantity), specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .frame(maxHeight: 150)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray6))
                        )

                        // Total
                        HStack {
                            Text("المجموع:")
                                .font(.headline)
                            Spacer()
                            Text("ل.د\(homeData.totalCost, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)

                    // Note Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("أضف ملاحظة")
                            .font(.headline)
                        TextEditor(text: $note)
                            .focused($isNoteFocused)
                            .frame(height: 100)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("تم") {
                                            isNoteFocused = false // Dismiss the keyboard
                                        }
                                    }
                                }
                    }
                    .padding(.horizontal)

                    // Confirm Button
                    Button(action: {
                        saveOrderData()
                        navigateToConfirmation = true
                    }) {
                        Text("تأكيد ووضع الطلب")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom)
            }
            .navigationDestination(isPresented: $navigateToConfirmation) {
                OrderConfirmationView()
            }
        }
    }

    
    
    func saveOrderData() {
        let userOrdersRef = db.collection("User_Orders")
        guard let user_id = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }
        
        // Current date when the order is placed
        let orderDate = Date()

        // Fetch the current order counter from Order_Meta
        let orderMetaRef = db.collection("Order_Meta").document("counter")
        orderMetaRef.getDocument { document, error in
            if let error = error {
                print("Error fetching order counter: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let currentCounter = document.data()?["OrderCounter"] as? Int else {
                print("Error: Order counter document not found or missing data")
                return
            }
            
            // Generate the new order_id
            let newOrderId = currentCounter + 1
            let newOrderIdString = String(format: "%06d", newOrderId) // Format as 6-digit number (e.g., 000001)

            // Update the order counter in Order_Meta for the next order
            orderMetaRef.updateData(["OrderCounter": newOrderId]) { error in
                if let error = error {
                    print("Error updating order counter: \(error.localizedDescription)")
                    return
                }
            }
            
            // Document data to save

            let orderItems = homeData.cartItems.map { cartItem in
                [
                    "item_name": cartItem.item.item_name,
                    "quantity": cartItem.quantity,
                    "cost": cartItem.item.item_cost
                ]
            }

            let total = homeData.cartItems.reduce(0.0) { $0 + ($1.item.item_cost * Double($1.quantity)) }

            let data: [String: Any] = [
                "user_id": user_id,
                "Order_Date": Timestamp(date: orderDate),
                "Delivery_Dates": selectedDates.map { Timestamp(date: $0) }, // Array of selected dates
                "Order_Items": orderItems, // Ordered items with quantities and cost
                "Total_Cost": total, // Total cost of the order
                "Customer_Note": note, // Optional customer note
                "Order_ID": newOrderIdString // Sequential Order ID as a string
            ]

            // 🚀 Use setData() with newOrderIdString as the document ID
            userOrdersRef.document(newOrderIdString).setData(data) { error in
                if let error = error {
                    print("Error saving order data: \(error.localizedDescription)")
                } else {
                    print("Order data successfully saved with Order ID: \(newOrderIdString)")
                }
            }
        }
    }


}

// Custom MultiDatePicker View
struct MultiDatePicker: View {
    @Binding var selectedDates: [Date]

    var body: some View {
        VStack {
            DatePicker("Select Dates", selection: Binding(
                get: { selectedDates.first ?? Date() },
                set: { newDate in
                    if !selectedDates.contains(newDate) {
                        selectedDates.append(newDate)
                    } else {
                        selectedDates.removeAll { $0 == newDate }
                    }
                }
            ), displayedComponents: .date)
            .datePickerStyle(.compact)
                .frame(maxHeight: 300)

            if !selectedDates.isEmpty {
                Text("Selected Dates:")
                    .font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedDates, id: \ .self) { date in
                            Text(date, style: .date)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.2))
                                )
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView(homeData: HomeViewModel())
}


