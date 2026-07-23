////
////  MedicineCardView.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 22/07/26.
////


import SwiftUI
internal import CoreData

struct MedicineCardView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var medicine: Medicine
    
    var onToggleTaken: () -> Void
    
    private var medName: String { medicine.name ?? "Medicine" }
    private var medDosage: String { medicine.dosage ?? "" }
    private var medCategory: String { medicine.category ?? "" }
    private var medFrequency: String { medicine.frequency ?? "" }
    private var medNextTime: String { medicine.nextTime ?? "" }
    
    private var daysRemaining: Int {
        Int(medicine.daysLeft)
    }
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.white.opacity(0.12))
                    .frame(width: 48, height: 48)
                
                Image(systemName: "pill.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(medName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if !medDosage.isEmpty {
                        Text(medDosage)
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.purple.opacity(0.15))
                            .foregroundColor(.orange)
                            .cornerRadius(6)
                    }
                }
                
                Text("\(medCategory) • \(medFrequency) • Next: \(medNextTime)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if daysRemaining > 0 && daysRemaining <= 5 {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                        
                        Text("Only \(medicine.daysLeft) days left")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.orange)
                    .padding(.top, 2)
                }
            }
            
            Spacer(minLength: 4)
            
            Button(action: toggleTakenStatus) {
                ZStack {
                    Circle()
                        .fill(medicine.isTaken ? Color.green.opacity(0.15) : Color.gray.opacity(0.12))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(medicine.isTaken ? .green : Color.gray.opacity(0.4))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
    
    private func toggleTakenStatus() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            medicine.isTaken.toggle()
            
            do {
                try viewContext.save()
                onToggleTaken() // Triggers parent view refresh
            } catch {
                print("❌ Core Data SAVE ERROR: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    let controller = PersistenceController.init(inMemory: true)
    let context = controller.container.viewContext
    
    let sampleMed = Medicine(context: context)
    sampleMed.name = "Aspirin"
    sampleMed.dosage = "100"
    sampleMed.category = "Headache"
    sampleMed.frequency = "Twice Daily"
    sampleMed.nextTime = "2:00 PM"
    sampleMed.daysLeft = 10
    sampleMed.isTaken = false
    
    return MedicineCardView(medicine: sampleMed, onToggleTaken: {})
        .padding()
}
