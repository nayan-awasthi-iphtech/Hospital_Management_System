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
            HomeScreen()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            AppointmentBookingHistory()
                .tabItem{
                    Label("Appointments", systemImage: "calendar.badge.clock")
                }
                .tag(1)
            
            DoctorScreenView()
                .tabItem{
                    Label("Doctors", systemImage: "person.badge.plus")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    RootTabView()
        .environment(\.managedObjectContext, context)
}
