//
//  NotificationSheet.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 27/07/26.
//

import SwiftUI
internal import CoreData

struct NotificationsSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var appointmentViewModel: AppointmentViewModel
    
    @ObservedObject var currentUser: User
    @Binding var selectedTab: Int
    
    
    private var UpcomingAppointments: [Appointment] {
        appointmentViewModel.appointments.filter { appointment in
            appointment.appointment_user == currentUser &&
            appointment.status?.lowercased() == "scheduled"
        }
    }
    
    
    var body: some View {
        ZStack {
            AppBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
        
                HStack {
                    Text("Notifications")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 16)
                
                Divider()
                
                if UpcomingAppointments.isEmpty {
                    
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "bell.slash.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary.opacity(0.6))
                        
                        Text("No Pending Appointments")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("You don't have any pending appointment requests at the moment.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(UpcomingAppointments, id: \.self) { appointment in
                                notificationCard(for: appointment)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
    }
    
    private func notificationCard(for appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "clock.badge.exclamationmark.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upcoming Appointments")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(doctorName(for: appointment))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Upcoming")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(8)
            }
            
            Divider()
            
            HStack {
                Label(formattedDate(appointment.date), systemImage: "calendar")
                Spacer()
                Label(formattedTime(appointment), systemImage: "clock")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
    
    private func doctorName(for appointment: Appointment) -> String {
        if let doctor = appointment.appointment_doctor {
            return "Dr. \(doctor.name ?? "Specialist")"
        }
        return "Doctor Appointment"
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Date TBD" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ appointment: Appointment) -> String {
        if let timeSlot = appointment.timeSlot, !timeSlot.isEmpty {
            return timeSlot
        }
        
        guard let date = appointment.date else { return "Time TBD" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
