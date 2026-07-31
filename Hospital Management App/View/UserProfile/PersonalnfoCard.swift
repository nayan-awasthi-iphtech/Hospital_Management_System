//
//  PersonalnfoCard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 31/07/26.
//

import SwiftUI

struct PersonalnfoCard: View {
    @ObservedObject var user: User
    
    private var formattedDOB: String {
        guard let dob = user.dob else { return "Not Provided" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "person.text.rectangle.fill")
                    .foregroundStyle(.blue)
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Personal Details")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "drop.fill",
                    label: "Blood Group",
                    value: user.bloodGroup ?? "A+"
                )
                Divider().opacity(0.3)
                InfoRow(
                    icon: "calendar",
                    label: "Date of Birth",
                    value: formattedDOB
                )
                Divider().opacity(0.3)
                InfoRow(
                    icon: "person.fill",
                    label: "Gender",
                    value: user.gender ?? "Male"
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
