import SwiftUI
internal import CoreData

struct RootTabView: View {
    
    @State private var selectedTab = 0
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var doctorViewModel = DoctorViewModel()
    
    var body: some View {
        Group {
            if let user = userViewModel.currentUser {
                SwiftUI.TabView(selection: $selectedTab) {
                    HomeScreen(selectedTab: $selectedTab, currentUser: user)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    AppointmentBookingHistory()
                        .tabItem {
                            Label("Appointments", systemImage: "calendar.badge.clock")
                        }
                        .tag(1)
                    
                    DoctorsListView(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Doctors", systemImage: "cross.case.fill")
                        }
                        .tag(2)
                    
                    MedicalReportsDashboard()
                        .tabItem {
                            Label("Reports", systemImage: "doc.text.fill")
                        }
                        .tag(3)
                    
                    UserProfileView()
                        .tabItem {
                            Label("User", systemImage: "person.fill")
                        }
                        .tag(4)
                }
                .tint(.blue)
                .environmentObject(user)
                .environmentObject(userViewModel)
                .environmentObject(doctorViewModel)
            } else {
                ContentUnavailableView("No User Found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
    }
}
