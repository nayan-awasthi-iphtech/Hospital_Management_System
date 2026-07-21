//
//  StatCard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

import SwiftUI

struct StatCard: View {
    
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8){
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

        Text(value)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.primary)
        
        Text(title)
            .font(.caption2)
            .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color:Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    StatCard(title: "Experience", value: "8+ Years", icon: "clock.fill", color: .orange)
}
