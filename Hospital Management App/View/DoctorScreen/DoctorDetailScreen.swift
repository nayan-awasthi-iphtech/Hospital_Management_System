//
//  DoctorDetailScreen.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

import SwiftUI
internal import CoreData

struct DoctorDetailScreen: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var isPresented: Bool = false
    
    @ObservedObject var doctor: Doctor
    
    var body: some View {
        VStack(spacing:24){
            VStack(spacing:16){
                ZStack(alignment: .bottomTrailing) {
                    if let binaryData = doctor.imageData, let uiImage = UIImage(data:binaryData){
                        Image(uiImage:uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.blue.opacity(0.8))
                            .background(Circle().fill(Color(.systemBackground)))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 22, height: 22)
                        .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 3))
                        .padding(.trailing, 4)
                        .padding(.bottom, 4)
                }
                
                VStack(spacing: 6) {
                    Text(doctor.name ?? "Unknown Doctor")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(doctor.department?.uppercased() ?? "GENERAL MEDICINE")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
            
            HStack(spacing: 50) {
                StatCard(title: "Experience", value: "8+ Years", icon: "clock.fill", color: .orange)
                StatCard(title: "Patients", value: "1.2K+", icon: "person.2.fill", color: .green)
                StatCard(title: "Rating", value: "4.9", icon: "star.fill", color: .yellow)
            }
            .padding(.horizontal, 20)
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("About Doctor")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(doctor.name ?? "this specialist") is a highly dedicated professional in \(doctor.department ?? "their field") with extensive clinical training. Committed to providing compassionate patient-centered healthcare options.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
        Button(action: {
            isPresented = true
        }) {
            Text("Book Appointment")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.blue)
                .cornerRadius(16)
                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
        .navigationDestination(isPresented:$isPresented){
            Appointment_Booking(doctor: doctor)
        }
        
        Spacer()
    }
}

#Preview {
    let mockData = try? PersistenceController.preview.container.viewContext.fetch(Doctor.fetchRequest()).first
    DoctorDetailScreen(doctor: mockData!)
}
