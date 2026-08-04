//
//  EmergencyContactCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct EmergencyContactCardView: View {
    
    let user: User
    
    private var contactPhoneString: String {
        guard let emr = user.emergencyContact else { return "Not Provided" }
        return "\(emr)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Emergency Contact")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "phone.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Emergency Contact")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(contactPhoneString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(contactPhoneString.isEmpty ? .red : .gray.opacity(0.4))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.cardBackground.opacity(0.65))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.cardBorder, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    let request: NSFetchRequest<User> = User.fetchRequest()
//    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
//    sampleUser.emergencyContact = 9876543210
//    
//    return ZStack {
//        Color(red: 0.96, green: 0.95, blue: 0.93)
//            .ignoresSafeArea()
//        EmergencyContactCardView(user: sampleUser)
//    }
//}
