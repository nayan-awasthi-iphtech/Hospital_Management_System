//
//  UserProfileView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct UserProfileView: View {
    @EnvironmentObject var currentUser: User
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    UserHeaderCardView(user: currentUser)
                    
                    Divider().opacity(0.5)
                    
                    UserInformationCardView(user: currentUser)
                    
                    Divider().opacity(0.5)
                    
                    EmergencyContactCardView(user: currentUser)
                    
                    Divider().opacity(0.5)
                    
                    InsuranceDetailsCardView(user: currentUser)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    
    UserProfileView()
        .environmentObject(sampleUser)
        .environment(\.managedObjectContext, context)
}
