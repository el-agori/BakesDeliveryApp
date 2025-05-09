//
//  Cart.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 13/11/2024.
//

import SwiftUI
struct Cart: Identifiable {
    var id  = UUID().uuidString
    var item : Item
    var quantity : Int
    
}
