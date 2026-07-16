//
//  UpcomingAppointmentCard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//
import SwiftUI

struct UpcomingAppointmentCard: View {

    let appointment: Appointment?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text("Upcoming Appointment")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("See all") {
                    // Action to handle navigation later
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 15)
      
            if let appt = appointment {
                VStack(spacing: 16) {
                    // Doctor Details Row
                    HStack(alignment: .center, spacing: 12) {
                        // Custom avatar badge
                        Image(systemName: "person.crop.circle.badge.checkmark.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Circle().fill(Color.blue.opacity(0.1)))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appt.appointment_doctor?.name ?? "Dr. Unknown Doctor")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(appt.appointment_doctor?.department ?? "General Health")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Dynamic Status Badge
                        Text(appt.status ?? "Scheduled")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(statusColor(for: appt.status))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(statusColor(for: appt.status).opacity(0.12))
                            )
                    }
                    
                    Divider()
                    
                    // Date & Time Row
                    HStack(spacing: 20) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            Text("Jul 18, 2026") // Dynamic date parsing can be formatted here later
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            Text("10:30 AM")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal, 15)
            } else {
                // Elegant Empty State
                HStack {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .foregroundColor(.secondary)
                    Text("No upcoming appointments scheduled")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                )
                .padding(.horizontal, 15)
            }
        }
    }
    

    private func statusColor(for status: String?) -> Color {
        switch status?.lowercased() {
        case "completed": return .green
        case "canceled": return .red
        default: return .orange // Pending / Scheduled
        }
    }
}
