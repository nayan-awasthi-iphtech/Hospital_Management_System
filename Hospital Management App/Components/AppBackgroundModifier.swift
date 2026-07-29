//
//  AppBackgroundModifier.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 27/07/26.
//

import SwiftUI

// 1. Reusable View Component
struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.93)
                .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.40),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 20,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.30),
                    Color.clear
                ],
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }
}

