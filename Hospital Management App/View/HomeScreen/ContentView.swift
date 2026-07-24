//
//  ContentView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct HomeScreen: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Binding var selectedTab: Int
    
    // CHANGED: Using NSSortDescriptor to prevent the NSObject conversion crash
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default
    ) private var users: FetchedResults<User>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.id, ascending: true)],
        animation: .default
    ) private var appointments: FetchedResults<Appointment>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.name, ascending: true)],
        animation: .default
    ) private var prescriptions: FetchedResults<Medicine>

    var body: some View {
        
        let currentUser = users.first
        
        let userAppointments = appointments.filter { $0.appointment_user == currentUser }
        let userPrescription = prescriptions.filter { $0.medicine_user == currentUser }
        
        NavigationStack {
            ZStack {
                // MARK: - Premium Warm Light Background
                ZStack {
                    // Base Soft Off-White / Cream
                    Color(red: 0.96, green: 0.95, blue: 0.93)
                        .ignoresSafeArea()
                    
                    // Top Light Gold/Champagne Glow (Complements header)
                    RadialGradient(
                        colors: [
                            Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.45),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 400
                    )
                    .ignoresSafeArea()
                    
                    // Mid Warm-Sand Ambient Glow (Complements card tones)
                    RadialGradient(
                        colors: [
                            Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 500
                    )
                    .ignoresSafeArea()
                }
                
                // MARK: - Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Header Card
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Good Morning,")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white.opacity(0.9))
                                
                                Text(currentUser?.name ?? "Alex Johnson")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                            
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.45, green: 0.32, blue: 0.22)) // Warm deep brown icon
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(.white)
                                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                                    )
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2)
                                    )
                                    .offset(x: -1, y: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 22)
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.72, green: 0.58, blue: 0.46),
                                        Color(red: 0.55, green: 0.41, blue: 0.30)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                RadialGradient(
                                    colors: [
                                        Color.black.opacity(0.0),
                                        Color.black.opacity(0.35)
                                    ],
                                    center: .bottomTrailing,
                                    startRadius: 40,
                                    endRadius: 220
                                )
                                
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 6)
                        .shadow(color: Color(red: 0.55, green: 0.41, blue: 0.30).opacity(0.25), radius: 18, x: 0, y: 8)
                        .padding(.horizontal, 14)
                        .padding(.top, 11)
                        
                        // Health Info Summary
                        HealthInfoCard()
                        
                        // Counter Cards
                        MetricCountersRow(
                            appointmentCount: userAppointments.count,
                            prescriptionCount: userPrescription.count,
                            reportCount: 4
                        )
                        
                        // Upcoming Appointments
                        UpcomingAppointmentCard(appointment: userAppointments.first, selectedTab: $selectedTab)
                        
                        // Pending Medicines
                        PendingMedicinesSection()
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}


//#Preview {
//    HomeScreen()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

