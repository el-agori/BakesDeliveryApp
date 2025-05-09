//
//  AlertView.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 02/12/2024.
//

import SwiftUI

struct AlertView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.black)
            .frame(width: UIScreen.main.bounds.width - 100, height: 120)
            .background(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

