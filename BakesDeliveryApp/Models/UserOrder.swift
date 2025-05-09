//
//  Orders.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 29/12/2024.
//

import SwiftUI
import FirebaseFirestore

struct UserOrder: Identifiable {
    var id: String
    var customerNote: String
    var deliveryDates: [Date]
    var orderDate: Date
    var orderItems: [OrderItem]
    var totalCost: Double
    var userId: String
}

struct OrderItem: Identifiable {
    var id = UUID() // Each order item needs a unique identifier
    var itemName: String
    var quantity: Int
    var cost: Double
}


