//
//  InsuranceDetailsCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct InsuranceDetailsCardView: View {
    
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .foregroundStyle(.blue)
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Insurance Details")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "cross.case.fill",
                    label: "Provider",
                    value: user.insuranceDetails ?? "Blue Cross Blue Shield"
                )
                Divider().opacity(0.3)
                InfoRow(
                    icon: "doc.text.fill",
                    label: "Policy No.",
                    value: user.policyId ?? "BCBS-2026-00842"
                )
                Divider().opacity(0.3)
                InfoRow(
                    icon: "checkmark.shield.fill",
                    label: "Coverage",
                    value: "Comprehensive"
                )
            }
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
        InsuranceDetailsCardView(user: sampleUser)
    }
}
