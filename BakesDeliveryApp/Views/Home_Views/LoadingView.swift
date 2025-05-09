//
//  LoadingView.swift
//  Make It So SL Live
//
//  Created by Haifa Zakaria on 02/12/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255)))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.8).ignoresSafeArea())
    }
}

