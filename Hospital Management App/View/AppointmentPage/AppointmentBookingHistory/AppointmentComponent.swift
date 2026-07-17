//
//  AppointmentBookinHistory.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

import SwiftUI

struct StatusBadge: View {
    
    let statusText: String
    
    var body: some View {
        Text(statusText == "Scheduled" ? "Upcoming" : statusText)
            .font(.system(size:11, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(badgeColor().opacity(0.12))
            .foregroundColor(badgeColor())
            .cornerRadius(8)
    }
    
    private func badgeColor() -> Color {
        switch statusText {
        case "Scheduled":
            return .blue
        case "Completed":
            return .green
        case "Cancelled":
            return .red
        default:
            return .gray
        }
    }
}

func parseAppointmentStatus(_ rawStatus: String?) -> (status: String, slot: String) {
    let raw = rawStatus ?? "Scheduled"
    let components = raw.components(separatedBy: " | ")
    let status = components.first ?? "Scheduled"
    
    var slot = "10:00 AM"
    
    if components.count > 1 {
        let extractedSlot = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        if !extractedSlot.isEmpty {
            slot = extractedSlot
        }
    }
    
    return (status, slot)
}

#Preview {
    StatusBadge(statusText: "Scheduled")
}
