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
            Color.appBackground
                .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    Color.appBackgroundTintTop,
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 20,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    Color.appBackgroundTintCenter,
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

