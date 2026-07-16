//
//  PendingMedicineScreen.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct PendingMedicinesSection: View {
    
    @Environment(\.managedObjectContext) var viewContext
    let prescriptions: [Prescription]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pending Medicines")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.horizontal, 15)

            if !prescriptions.isEmpty {
                VStack(spacing: 12) {
                    ForEach(prescriptions, id: \.self) { prescription in
                        MedicineRowView(prescription: prescription)
                    }
                }
                .padding(.horizontal, 15)
            } else {
                // Empty state fallback card
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("All medicines taken for today!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal, 15)
            }
        }
    }
}

struct MedicineRowView: View {
    let prescription: Prescription
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Pill Icon Badge Container
            Image(systemName: "pill.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.teal)
                .padding(12)
                .background(Color.teal.opacity(0.1))
                .clipShape(Circle())
            
            
            VStack(alignment: .leading, spacing: 4) {
         
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(prescription.medicineName ?? "Unknown Medicine")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(prescription.dosage ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Scheduled intake time string
                Text("Take Next Prescription on time")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status Alert "Due" pill
            Text("Due")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.orange.opacity(0.12))
                )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
PendingMedicinesSection(prescriptions: [])
}
