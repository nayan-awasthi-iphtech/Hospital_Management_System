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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.date, ascending: false)])
    var appointments: FetchedResults<Appointment>
    
    @State private var selectedTab = 0
    
    @State private var appointemntToReschedule: Appointment? = nil
    @State private var isShowingRescheduleSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    ForEach(filteredAppointments) { app in
                        AppointmentCardView(
                            appointment: app,
                            onCancel: { cancelAppointment(app) },
                            onReschedule: {
                                print(app)
                                appointemntToReschedule = app
                                isShowingRescheduleSheet = true
                            }
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .onDelete(perform: deleteAppointmentItems)
                }
                .listStyle(.plain)
                .background(Color(.systemGroupedBackground))
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
    
    private var filteredAppointments: [Appointment] {
        
        if selectedTab == 0 {
            
            return appointments.filter { app in
                let status = app.status ?? ""
                return status.localizedCaseInsensitiveContains("Scheduled") || status.isEmpty
            }
        } else {
            // History Tab: Cancelled ya Completed items
            return appointments.filter { app in
                let status = app.status ?? ""
                return status.localizedCaseInsensitiveContains("Cancelled") ||
                status.localizedCaseInsensitiveContains("Completed") ||
                status.localizedCaseInsensitiveContains("Canceled")
            }
        }
    }
    
    private func cancelAppointment(_ app: Appointment) {
        let current = parseAppointmentStatus(app.status)
        app.status = "Cancelled | \(current.slot)"
        try? viewContext.save()
    }
    
    private func deleteAppointmentItems(at offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredAppointments[$0] }.forEach(viewContext.delete)
            
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
