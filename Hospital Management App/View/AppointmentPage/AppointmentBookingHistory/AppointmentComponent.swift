//
//  StatusBadge.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

import SwiftUI

struct StatusBadge: View {
    let statusText: String
    
    var body: some View {
        Text(statusText == "Scheduled" ? "Upcoming" : statusText)
            .font(.system(size: 11, weight: .semibold))
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
        case "Cancelled", "Canceled":
            return .red
        default:
            return .gray
        }
    }
}

extension Appointment {
    var safeStatus: String {
        self.status ?? "Scheduled"
    }
    
    var safeTimeSlot: String {
        self.timeSlot ?? "10:00 AM"
    }
}

#Preview {
    StatusBadge(statusText: "Scheduled")
}
