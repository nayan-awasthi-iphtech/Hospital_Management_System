//
//  BMICalculator.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 22/07/26.
//

import SwiftUI
internal import CoreData

struct BMICalculatorView: View {
    
    let currentUser: User
    
    private var currentBMIString: String {
        guard let heightStr = currentUser.height,
              let weightStr = currentUser.weight,
              let heightVal = Double(heightStr),
              let weightVal = Double(weightStr) else {
            return "23.8"
        }
        
        let bmiDouble = bmiCalculatorDouble(height: heightVal, weight: weightVal)
        return String(format: "%.1f", bmiDouble)
    }
    
    private func bmiCalculatorDouble(height: Double, weight: Double) -> Double {
        guard height > 0 else { return 0.0 }
        let bmi = weight / pow(height / 100, 2)
        return bmi
    }
    
    private var currentBMIDouble: Double {
        guard let heightStr = currentUser.height,
              let weightStr = currentUser.weight,
              let heightVal = Double(heightStr),
              let weightVal = Double(weightStr) else {
            return 23.8
        }
        
        return bmiCalculatorDouble(height: heightVal, weight: weightVal)
    }
    
    private var bmiStatus: String {
        switch currentBMIDouble {
        case ..<18.5:
            return "Underweight"
        case 18.5..<24.9:
            return "Normal"
        case 25..<29.9:
            return "Overweight"
        default:
            return "Obese"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("BMI Calculator")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
            
                VStack(alignment: .leading, spacing: 6) {
                    Text("Height (cm)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(currentUser.height ?? "175")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                }
            
                VStack(alignment: .leading, spacing: 6) {
                    Text("Weight (kg)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(currentUser.weight ?? "70")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your BMI")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(currentBMIString)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text(bmiStatus)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 0.02, green: 0.75, blue: 0.45))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.02, green: 0.75, blue: 0.45).opacity(0.12))
                    .cornerRadius(8)
            }
            .padding(16)
            .background(Color.blue.opacity(0.04))
            .cornerRadius(14)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.65))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.8), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    
    ZStack {
        Color(red: 0.96, green: 0.95, blue: 0.93)
            .ignoresSafeArea()
        BMICalculatorView(currentUser: sampleUser)
    }
}
