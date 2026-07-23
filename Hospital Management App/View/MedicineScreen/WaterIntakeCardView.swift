//
//  WaterIntakeCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 22/07/26.
//

import SwiftUI

struct WaterIntakeCardView: View {
    
    @State private var currentGlasses: Int = 4
    private let totalGlasses: Int = 8
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                    
                    Text("Water Intake")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("\(currentGlasses)/\(totalGlasses) glasses")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            HStack(spacing: 10) {
                ForEach(0..<totalGlasses, id: \.self) { index in
                    Circle()
                        .fill(index < currentGlasses ? Color.blue : Color.blue.opacity(0.08))
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(.vertical, 4)
            
            HStack(spacing: 12) {
                Button(action: removeGlass) {
                    Text("- Remove")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(2)
                }
                .disabled(currentGlasses <= 0)
                .opacity(currentGlasses <= 0 ? 0.5 : 1.0)
                
                Button(action: addGlass) {
                    Text("+ Add Glass")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.12))
                        .cornerRadius(2)
                }
                .disabled(currentGlasses >= totalGlasses)
                .opacity(currentGlasses >= totalGlasses ? 0.5 : 1.0)
            }
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
    
    private func addGlass() {
        if currentGlasses < totalGlasses {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                currentGlasses += 1
            }
        }
    }
    
    private func removeGlass() {
        if currentGlasses > 0 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                currentGlasses -= 1
            }
        }
    }
}

#Preview {
    WaterIntakeCardView()
        .padding()
}
