//
//  Task.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 06/10/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

struct Item: Codable, Identifiable {
    @DocumentID var id: String?
   // var title: String
    var item_name: String
    var item_description: String
    var item_cost: Double
    // Optional, in case there is no Rating...
    var Item_ratings: String
    // Optional, in case there is no image...
    var item_image: String
    // to identify wheather it is added to Cart ...
    var isAdded : Bool = false
    var isFavorite: Bool = false
    var quantity: Int = 0  // New property for quantity
    
    
    
}


