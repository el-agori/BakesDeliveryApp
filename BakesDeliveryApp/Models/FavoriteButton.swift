//
//  FavoriteButton.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 06/01/2025.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var item: Item

    var body: some View {
        Button(action: {
            item.isFavorite.toggle()
        }) {
            Image(systemName: item.isFavorite ? "heart.fill" : "heart.fill")
                .foregroundColor(item.isFavorite ? Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255) : .white)
                .font(.system(size: 30))
        }
    }
}
