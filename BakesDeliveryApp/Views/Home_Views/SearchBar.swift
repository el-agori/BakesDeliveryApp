//
//  SearchBar.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 02/12/2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var search: String

    var body: some View {
        HStack(spacing: 15) {
            
            if !search.isEmpty {
                            Button(action: {
                                search = "" // Reset search query
                            }) {
                                Image(systemName: "x.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .accessibilityLabel("Clear search")
                        }

            TextField("البحث", text: $search)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        
        
           
              
        
    }
}

