//
//  DoctorScreenView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct DoctorScreenView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    var body: some View {
        NavigationStack{
            DoctorsListView()
        }
    }
}

#Preview {
    DoctorScreenView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
