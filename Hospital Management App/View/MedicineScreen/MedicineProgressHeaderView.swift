////
////  MedicineProgressHeaderView.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 22/07/26.

import SwiftUI

struct MedicineProgressHeaderView: View {
    let takenCount: Int
    let totalCount: Int
    
    private var progressRatio: Double {
        guard totalCount > 0 else { return 0 }
        return Double(takenCount) / Double(totalCount)
    }
    
    private var remainingCount: Int {
        max(0, totalCount - takenCount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today Progress")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.85))
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(takenCount)/\(totalCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Taken")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            ProgressView(value: progressRatio)
                .tint(.white)
                .background(.white.opacity(0.4))
                .scaleEffect(y: 2)
            
            Text("\(remainingCount) medicine\(remainingCount == 1 ? "" : "s") remaining")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(20)
        .background(
            ZStack(alignment: .trailing) {
                LinearGradient(
                    colors: [Color(red: 0.02, green: 0.78, blue: 0.58), Color(red: 0.0, green: 0.68, blue: 0.50)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 90, height: 90)
                    .offset(x: -2, y: -20)
            }
        )
        .cornerRadius(20)
        .shadow(color: Color.green.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    MedicineProgressHeaderView(takenCount: 2, totalCount: 5)
        .padding()
}
