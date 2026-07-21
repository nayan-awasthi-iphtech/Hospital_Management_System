//
//  TabView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct RootTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)]
    ) private var users: FetchedResults<User>
    
    private var currentUser: User? {
        users.first
    }

    var body: some View {
        Group {
            if let user = currentUser {
                SwiftUI.TabView(selection: $selectedTab) {
                    HomeScreen(selectedTab: $selectedTab)
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(0)
                    
                    AppointmentBookingHistory()
                        .tabItem { Label("Appointments", systemImage: "calendar.badge.clock") }
                        .tag(1)
                    
                    DoctorsListView(selectedTab: $selectedTab)
                        .tabItem { Label("Doctors", systemImage: "person.badge.plus") }
                        .tag(2)
                    
                    MedicalReportsDashboard()
                        .tabItem { Label("Reports", systemImage: "doc.badge.plus") }
                        .tag(3)
                    
                    UserProfileView()
                        .tabItem { Label("User", systemImage: "person.fill") }
                        .tag(4)
                }
                .tint(.blue)
                .environmentObject(user)
            } else {
                ContentUnavailableView("No User Found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    
    return RootTabView()
        .environment(\.managedObjectContext, context)
        .environmentObject(sampleUser)
}
