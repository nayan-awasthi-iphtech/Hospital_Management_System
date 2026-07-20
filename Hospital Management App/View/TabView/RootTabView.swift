//
//  TabView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct RootTabView: View {
    
    @State private var selectedTab = 0
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        SwiftUI.TabView(selection: $selectedTab){
            HomeScreen(selectedTab:$selectedTab)
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            AppointmentBookingHistory()
                .tabItem{
                    Label("Appointments", systemImage: "calendar.badge.clock")
                }
                .tag(1)
            
            DoctorsListView(selectedTab: $selectedTab)
                .environment(\.managedObjectContext, viewContext)
                .tabItem{
                    Label("Doctors", systemImage: "person.badge.plus")
                }
                .tag(2)
            
            MedicalReportsDashboard()
                .tabItem{
                    Label("Reports", systemImage: "doc.badge.plus")
                }
                .tag(3)
        }
        .tint(.blue)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    RootTabView()
        .environment(\.managedObjectContext, context)
}
