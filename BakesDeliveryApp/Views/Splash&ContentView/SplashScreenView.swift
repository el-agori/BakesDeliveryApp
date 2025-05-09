//
//  SplashScreenView.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 31/12/2024.
//


import SwiftUI

struct SplashScreenView: View {
    @State private var isSplashActive = true
    let title = " بريوش "

    var body: some View {
        ZStack {
            // Background Image
            Image(uiImage: UIImage(named: "SplashImage")!)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.3)) // Adds a dark overlay for better text visibility

            VStack {
                Spacer()

                // Animated Title
                AnimatedTitleView(title: title)
                    .padding()

                Spacer()

                // Bottom Content (e.g., Logo or Welcome Back)
                HStack {
                    Text("مرحباً بك")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill( Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255)
                                    .opacity(0.8))
                                .shadow(radius: 5)
                        )
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct AnimatedTitleView: View {
    let title: String
    @State private var isAnimating = false

    var body: some View {
        Text(title)
            .font(.system(size: 70, weight: .bold))
            .foregroundColor(.white)
            .shadow(color: Color(red: 1.0, green: 0.4, blue: 0), radius: 10, x: 0, y: 0)
            .scaleEffect(isAnimating ? 1.1 : 0.9)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    SplashScreenView()
}



