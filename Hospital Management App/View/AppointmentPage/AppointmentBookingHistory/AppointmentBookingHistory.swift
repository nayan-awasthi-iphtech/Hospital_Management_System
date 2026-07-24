//
//  AppointmentBookingHistory.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import SwiftUI
internal import CoreData

struct AppointmentBookingHistory: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default
    ) private var users: FetchedResults<User>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.date, ascending: false)],
        animation: .default
    ) private var appointments: FetchedResults<Appointment>
    
    @State private var selectedTab = 0
    @State private var appointemntToReschedule: Appointment? = nil
    
    var body: some View {
        let currentUser = users.first
        
        ZStack {
            // MARK: - Premium Warm Light Background Canvas
            ZStack {
                // Base Soft Off-White / Cream
                Color(red: 0.96, green: 0.95, blue: 0.93)
                    .ignoresSafeArea()
                
                // Top Light Gold Glow
                RadialGradient(
                    colors: [
                        Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.40),
                        Color.clear
                    ],
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 400
                )
                .ignoresSafeArea()
                
                // Mid Warm Ambient Glow
                RadialGradient(
                    colors: [
                        Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.30),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 50,
                    endRadius: 500
                )
                .ignoresSafeArea()
            }
            
            VStack(spacing: 12) {
                // MARK: - Centered Top Title Header
                Text("Appointments")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.12))
                    .tracking(0.5)

                
                Picker("", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                
                if filteredAppointments(for: currentUser).isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        "No Appointments",
                        systemImage: "calendar.badge.clock",
                        description: Text(selectedTab == 0 ? "You don't have any upcoming appointments scheduled." : "Your appointment history is empty.")
                    )
                    .foregroundStyle(Color(red: 0.45, green: 0.38, blue: 0.32))
                    Spacer()
                } else {
                    List {
                        ForEach(filteredAppointments(for: currentUser)) { app in
                            AppointmentCardView(
                                appointment: app,
                                onCancel: { cancelAppointment(app) },
                                onReschedule: {
                                    appointemntToReschedule = app
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete(perform: { offsets in
                            deleteAppointmentItems(at: offsets, for: currentUser)
                        })
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .sheet(item: $appointemntToReschedule) { targetAppointment in
            RescheduleSheetView(
                appointment: targetAppointment,
                onDismiss: {
                    self.appointemntToReschedule = nil
                }
            )
        }
    }
    
    private func filteredAppointments(for user: User?) -> [Appointment] {
        guard let currentUser = user else { return [] }
        
        let userAppointments = appointments.filter { $0.appointment_user == currentUser }
        
        if selectedTab == 0 {
            return userAppointments.filter { app in
                let status = app.status ?? ""
                return status.localizedCaseInsensitiveContains("Scheduled") || status.isEmpty
            }
        } else {
            return userAppointments.filter { app in
                let status = app.status ?? ""
                return status.localizedCaseInsensitiveContains("Cancelled") ||
                status.localizedCaseInsensitiveContains("Completed") ||
                status.localizedCaseInsensitiveContains("Canceled")
            }
        }
    }
    
    private func cancelAppointment(_ app: Appointment) {
        withAnimation {
            app.status = "Cancelled"
            
            do {
                try viewContext.save()
                print("✅ Core Data targeted pipeline flushed successfully!")
            } catch {
                print("❌ Context update tracking error: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteAppointmentItems(at id: IndexSet, for user: User?) {
        let itemsToDelete = id.map { filteredAppointments(for: user)[$0] }
        
        withAnimation {
            itemsToDelete.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
                print("Success: Selected History item deleted permanently!")
            } catch {
                print("Failed to clear Core Data node: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    AppointmentBookingHistory()
        .environment(\.managedObjectContext, context)
}
