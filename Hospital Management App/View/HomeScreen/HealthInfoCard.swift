//
//  Untitled.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI

struct HealthInfoCard: View {
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 16){
            Text("Health Summary")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing:30){
                VStack(alignment: .leading, spacing: 4) {
                    Text("Heart Rate")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("73")
                            .font(.title)
                            .bold()
                        Text("bpm")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Blood Pressure")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("120/80")
                            .font(.title)
                            .bold()
                        Text("mmHg")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                }
            }
            HStack(spacing: 4){
                HStack(spacing: 4) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 10))
                    Text("Active")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.15)))
                
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 10))
                    Text("O₂ 98%")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.15)))
                
                HStack(spacing: 4) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 10))
                    Text("6.2k steps")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.15)))
            }
        }
        
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.gray.opacity(1.5), Color.brown.opacity(1.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .padding(.horizontal, 15)
    }
}

#Preview {
    HealthInfoCard()
}
