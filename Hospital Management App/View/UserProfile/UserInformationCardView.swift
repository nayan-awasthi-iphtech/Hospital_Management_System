//
//  UserInformationCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct UserInformationCardView: View {
    
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "person.text.rectangle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.blue)
                    .padding(10)
                    .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Personal Information")
                        .font(.title3).bold()
                        .foregroundStyle(.primary)
                    Text("Patient details")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .padding(.bottom, 4)

            Divider().opacity(0.5)

            VStack(spacing: 14) {
                InfoRow(icon: "person.fill", label: "Full Name", value: user.name ?? "Alex")
                Divider().opacity(0.3)
                InfoRow(icon: "calendar", label: "Date of birth", value: formatDate(for: user.dob))
                Divider().opacity(0.3)
                InfoRow(icon: "figure.arms.open", label: "Gender", value: user.gender ?? "Male")
                Divider().opacity(0.3)
                InfoRow(icon: "bandage.fill", label: "Allergies", value: user.allergies ?? "None")
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
    
    private func formatDate(for date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        if let date = date {
            return formatter.string(from: date)
        } else {
            return "—"
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    
    ZStack {
        Color(red: 0.96, green: 0.95, blue: 0.93)
            .ignoresSafeArea()
        UserInformationCardView(user: sampleUser)
    }
}

struct InfoRow: View {
    
    let icon: String?
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 18)
            }

            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(minWidth: 90, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
    }
}
