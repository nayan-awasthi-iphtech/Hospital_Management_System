//
//  UpcomingAppointments.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI

struct MetricCountersRow: View {
    let appointmentCount: Int
    let prescriptionCount: Int
    let reportCount: Int
    
    var body: some View {
        HStack(spacing: 12) {
            
            // 1. Appointments Card
            MetricCounterCard(
                count: appointmentCount,
                title: "Appointments",
                iconName: "calendar.badge.clock",
                iconColor: .blue
            )
          
            MetricCounterCard(
                count: reportCount,
                title: "Reports",
                iconName: "doc.text.fill",
                iconColor: .teal
            )
            
            // 3. Medicines Card
            MetricCounterCard(
                count: prescriptionCount,
                title: "Medicines",
                iconName: "pill.fill",
                iconColor: .orange
            )
        }
        .padding(.horizontal, 15)
    }
}

struct MetricCounterCard: View {
    let count: Int
    let title: String
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon Badge Top Left
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(iconColor)
                .padding(10)
                .background(iconColor.opacity(0.12)) // Light tinted background behind the icon
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 2) {
                // Number Counter Value
                Text("\(count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Card Text Label
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading) // Spreads columns symmetrically across any iPhone width
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white) // High contrast card background
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3) // Soft floating shadow
        )
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        VStack {
            MetricCountersRow(
                appointmentCount: 2,
                prescriptionCount: 3,
                reportCount: 4
            )
            Spacer()
        }
        .padding(.top)
    }
}
