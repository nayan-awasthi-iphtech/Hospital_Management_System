//
//  PendingMedicineScreen.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct PendingMedicinesSection: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Auto-fetching only pending medicines from Core Data
    @FetchRequest(
        entity: Medicine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.name, ascending: true)],
        predicate: NSPredicate(format: "isTaken == %@", NSNumber(value: false)),
        animation: .default
    ) private var pendingMedicines: FetchedResults<Medicine>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pending Medicines")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.horizontal, 15)

            if !pendingMedicines.isEmpty {
                VStack(spacing: 12) {
                    ForEach(pendingMedicines) { medicine in
                        MedicineRowView(medicine: medicine)
                    }
                }
                .padding(.horizontal, 15)
            } else {
                // Empty state fallback card
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                    
                    Text("All medicines taken for today!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal, 15)
            }
        }
    }
}

struct MedicineRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var medicine: Medicine
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Pill Icon Badge Container
            Image(systemName: "pill.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(medicine.isTaken ? .green : .teal)
                .padding(12)
                .background((medicine.isTaken ? Color.green : Color.teal).opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(medicine.name ?? "Unknown Medicine")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if let dosage = medicine.dosage, !dosage.isEmpty {
                        Text(dosage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(medicine.isTaken ? "Completed" : "Take Next Prescription on time")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
                Text(medicine.isTaken ? "Taken" : "Due")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(medicine.isTaken ? .green : .orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill((medicine.isTaken ? Color.green : Color.orange).opacity(0.12))
                    )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    let controller = PersistenceController.init(inMemory: true)
    let context = controller.container.viewContext
    Medicine.MedicineDummyData(viewContext: context)
    
    return PendingMedicinesSection()
        .environment(\.managedObjectContext, context)
}
