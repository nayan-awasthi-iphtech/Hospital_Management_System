import SwiftUI
internal import CoreData

struct RootTabView: View {
    @State private var selectedTab = 0
    
    private var currentUser: User? {
        PersistenceController.shared.currentUser
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        Group {
            if let user = currentUser {
                SwiftUI.TabView(selection: $selectedTab) {
                    HomeScreen(selectedTab: $selectedTab)
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
                    
                    MedicineDetailView()
                        .tabItem {
                            Label("Medicine", systemImage: "pill.fill")
                        }
                        .tag(5)
                }
                .tint(.blue)
                .environmentObject(user)
            } else {
                ContentUnavailableView("No User Found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
    }
}
