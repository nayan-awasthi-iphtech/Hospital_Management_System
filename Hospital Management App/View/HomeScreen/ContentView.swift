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
    @Binding var selectedTab:Int
    
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
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Good Morning,")
                                    .foregroundStyle(.secondary)
                                    .font(.title3)
                                
                                Text(currentUser?.name ?? "Alex Johnson")
                                    .foregroundStyle(.primary)
                                    .font(.title2)
                                    .bold()
                            }
                            .padding(.horizontal, 15)
                            
                            Spacer()
                            
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(.systemGray2))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                                    )
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: -2, y: 2)
                            }
                            .padding(.horizontal, 15)
                        }
                        .padding(.top, 15)
                        
                        HealthInfoCard()
                        
                        MetricCountersRow(
                            appointmentCount:  userAppointments.count,
                            prescriptionCount: userPrescription.count,
                            reportCount: 4
                        )
                        
                        UpcomingAppointmentCard(appointment: userAppointments.first, selectedTab:$selectedTab)
                        
                        PendingMedicinesSection()
                    }
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

