import SwiftUI
internal import CoreData

struct HomeScreen: View {
    
    @Binding var selectedTab: Int
    
    @State private var showNotificationsSheet: Bool = false
    @State private var showCompleteProfileAlert: Bool = false
    @State private var showCompleteProfileSheet: Bool = false
    @State private var hasProfileCompleteCheck: Bool = false
    
    @StateObject private var appointmentViewModel = AppointmentViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.name, ascending: true)],
        animation: .default
    ) private var medicines: FetchedResults<Medicine>
    
    @ObservedObject var currentUser: User
    
    private var upcomingUserAppointment: [Appointment] {
        appointmentViewModel.UpcomingAppointment
    }
    
    private var hasUpcomingAppointment: Bool {
        !appointmentViewModel.UpcomingAppointment.isEmpty
    }
    
    var body: some View {
        let userAppointments = appointmentViewModel.appointments.filter { $0.appointment_user == currentUser }
        
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        
                        UserHeaderCard(currentUser: currentUser, hasUpcomingAppointment: hasUpcomingAppointment, onNotificationTap: {
                            showNotificationsSheet = true
                        }
                        )
                        HealthInfoCard()
                        
                        MetricCountersRow(
                            appointmentCount: userAppointments.count,
                            prescriptionCount: medicines.count,
                            reportCount: currentUser.user_report?.count ?? 0
                        )
                        UpcomingAppointmentCard(
                            appointment: appointmentViewModel.UpcomingAppointment.sorted{
                                ($0.date ?? Date()) < ($1.date ?? Date())
                            }.first,
                            selectedTab: $selectedTab)
                        
                        PendingMedicinesSection()
                    }
                    .padding(.bottom, 24)
                }
            }
            .alert("Complete Your Profile", isPresented: $showCompleteProfileAlert) {
                Button("Update Now") {
                    showCompleteProfileSheet = true
                }
                Button("Later", role: .cancel) { }
            } message: {
                Text("Your medical profile details (blood group, emergency contact, etc.) are incomplete. Please complete them for better care management.")
            }
            
            .sheet(isPresented: $showCompleteProfileSheet) {
                UserCompleteProfileView()
                    .environmentObject(UserViewModel())
            }
            .sheet(isPresented: $showNotificationsSheet) {
                NotificationsSheet(currentUser: currentUser, selectedTab: $selectedTab)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .onAppear{
                appointmentViewModel.fetchAppointments()
                if !hasProfileCompleteCheck {
                    hasProfileCompleteCheck = true
                    if authViewModel.isAnyDetailMissing(for: currentUser){
                        showCompleteProfileAlert = true
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
