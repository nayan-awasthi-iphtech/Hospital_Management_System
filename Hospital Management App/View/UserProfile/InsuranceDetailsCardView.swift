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
        VStack(alignment: .leading, spacing: 14){
            HStack{
                Image(systemName: "shield.fill")
                    .foregroundStyle(.blue)
                
                Text("Insurance Details")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            VStack(spacing:10){
                InfoRow(
                    icon: "cross.case.fill",
                    label: "Provider",
                    value: user.insuranceDetails ?? "Blue Cross Blue Shield",
                )
                
                InfoRow(
                    icon: "doc.text.fill",
                    label: "Policy No.",
                    value: user.policyId ?? "BCBS-2026-00842",
                )
                
                InfoRow(
                    icon: "checkmark.shield.fill",
                    label: "Coverage",
                    value: "Comprehensive",
                )
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    InsuranceDetailsCardView(user: sampleUser)
}
