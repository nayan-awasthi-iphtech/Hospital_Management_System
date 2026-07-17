//
//  AppointmentCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import SwiftUI
internal import CoreData

struct AppointmentCardView: View {
    @ObservedObject var appointment: Appointment
    var onCancel: () -> Void
    var onReschedule: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
              
                if let doctor = appointment.appointment_doctor {
                    DoctorImageView(data: doctor.imageData)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(doctor.name ?? "Unknown Doctor")
                            .font(.system(size: 16, weight: .bold))
                        Text(doctor.department ?? "Specialist")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                } else {
                    Image(systemName: "person.badge.clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue.opacity(0.6))
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("General Appointment")
                            .font(.system(size: 16, weight: .bold))
                        Text("Hospital Visit")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                StatusBadge(statusText: parseAppointmentStatus(appointment.status).status)
            }
            
            HStack(spacing: 16) {
                MetaIcon(icon: "calendar", text: appointment.date?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                MetaIcon(icon: "clock", text: parseAppointmentStatus(appointment.status).slot)
                Spacer()
                MetaIcon(icon: "doc.text", text: "Check-up")
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.secondary)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            if parseAppointmentStatus(appointment.status).status == "Scheduled" {
                HStack(spacing: 12) {
                    Button("Cancel", action: onCancel).buttonStyle(ActionButtonStyle(color: .red))
                    
                    Button("Reschedule", action: {onReschedule()}).buttonStyle(ActionButtonStyle(color: .blue))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
    }
}

struct DoctorImageView: View {
    let data: Data?
    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 50, height: 50).clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill").resizable().frame(width: 50, height: 50).foregroundColor(.gray)
        }
    }
}

struct MetaIcon: View {
    let icon: String; let text: String
    var body: some View {
        HStack(spacing: 6) { Image(systemName: icon).foregroundColor(.blue); Text(text) }
    }
}

struct ActionButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(color)
            .frame(maxWidth: .infinity).frame(height: 38)
            .background(color.opacity(0.08)).cornerRadius(10)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let request: NSFetchRequest<Appointment> = Appointment.fetchRequest()
    let mockAppointment = (try? context.fetch(request))?.first ?? Appointment(context: context)
    
ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
    AppointmentCardView(appointment: mockAppointment, onCancel: {}, onReschedule: {})
            .padding()
    }
    .environment(\.managedObjectContext, context)
}

