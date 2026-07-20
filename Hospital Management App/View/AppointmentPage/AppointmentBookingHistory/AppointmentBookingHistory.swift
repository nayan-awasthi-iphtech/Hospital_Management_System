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
    )  private var appointments:FetchedResults<Appointment>
    
    @State private var selectedTab = 0
    @State private var appointemntToReschedule: Appointment? = nil
    
    var body: some View {
        let currentUser = users.first
        
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if filteredAppointments(for: currentUser).isEmpty {
                    ContentUnavailableView(
                        "No Appointments",
                        systemImage: "calendar.badge.clock",
                        description: Text(selectedTab == 0 ? "You don't have any upcoming appointments scheduled." : "Your appointment history is empty.")
                    )
                    .background(Color(.systemGroupedBackground))
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
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                        .onDelete(perform: { offsets in
                            deleteAppointmentItems(at: offsets, for: currentUser)
                        })
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Appointments")
            .sheet(item: $appointemntToReschedule) { targetAppointment in
                RescheduleSheetView(
                    appointment: targetAppointment,
                    onDismiss: {
                        self.appointemntToReschedule = nil
                    }
                )
            }
        }
    }
    
    private func filteredAppointments(for user: User?) -> [Appointment] {
        guard let currentUser = user else { return [] }
        
        let userAppointments = appointments.filter { $0.appointment_user == currentUser}
        
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
        withAnimation{
            app.status = "Cancelled"
            
            do {
                try viewContext.save()
                print("✅ Core Data targeted pipeline flushed successfully!")
            } catch {
                print("❌ Context update tracking error: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteAppointmentItems(at offsets: IndexSet, for user: User?) {
        let itemsToDelete = offsets.map { filteredAppointments(for: user)[$0] }
        
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
