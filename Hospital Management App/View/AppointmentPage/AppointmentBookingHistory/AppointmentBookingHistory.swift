import SwiftUI
internal import CoreData

struct AppointmentBookingHistory: View {
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var viewModel = AppointmentViewModel()
    
    @State private var selectedTab = 0
    @State private var appointemntToReschedule: Appointment? = nil
    @State private var showConfirmDeleteAppt: Bool = false
    @State private var ApptToDelete: [Appointment] = []
    
    private var currentUser: User? {
        return SessionManager.shared.getActiveUser(in: viewContext)
    }
    
    private var currentList: [Appointment] {
        selectedTab == 0 ? viewModel.UpcomingAppointment: viewModel.passedAppointment
    }
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack(spacing: 12) {
                Text("Appointments")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color.primaryText)
                    .tracking(0.5)
                
                Picker("", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                
                if currentList.isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        "No Appointments",
                        systemImage: "calendar.badge.clock",
                        description: Text(selectedTab == 0 ? "You don't have any upcoming appointments scheduled." : "Your appointment history is empty.")
                    )
                    .foregroundStyle(Color.secondaryText)
                    Spacer()
                } else {
                    List {
                        ForEach(currentList) { app in
                            AppointmentCardView(
                                appointment: app,
                                onCancel: {
                                    withAnimation{
                                        viewModel.cancelAppointment(app)
                                    }
                                },
                                onReschedule: {
                                    viewModel.appointemntToReschedule  = app
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete{offsets in
                            viewModel.prepareForDelete(at: offsets, from: currentList)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .onAppear {
            viewModel.fetchAppointments()
        }
        .sheet(item: $viewModel.appointemntToReschedule) { targetAppointment in
            RescheduleSheetView(
                appointment: targetAppointment,
                onDismiss: {
                    viewModel.appointemntToReschedule = nil
                    viewModel.fetchAppointments()
                }
            )
        }
        .alert("Delete Appointment", isPresented: $viewModel.showConfirmDeleteAppt) {
            Button("Delete", role: .destructive) {
                viewModel.deleteSelectedAppoitments()
            }
            Button("Cancel", role: .cancel) {
                viewModel.ApptToDelete.removeAll()
            }
        } message: {
            Text(
                viewModel.ApptToDelete.count > 1 ? "Are you sure you want to delete the selected appointments? This action cannot be undone." : "Are you sure you want to delete the selected appointment? This action cannot be undone."
            )
        }
    }
}
