//
//  Hospital_Management_AppApp.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

@main
struct Hospital_Management_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
