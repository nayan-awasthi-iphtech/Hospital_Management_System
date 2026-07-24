////
////  UserProfileView.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 21/07/26.
////
//
//import SwiftUI
//internal import CoreData
//
//struct UserProfileView: View {
//    @EnvironmentObject var currentUser: User
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 30) {
//                    UserHeaderCardView(user: currentUser)
//                    
//                    Divider().opacity(0.5)
//                    
//                    UserInformationCardView(user: currentUser)
//                    
//                    Divider().opacity(0.5)
//                    
//                    EmergencyContactCardView(user: currentUser)
//                    
//                    Divider().opacity(0.5)
//                    
//                    InsuranceDetailsCardView(user: currentUser)
//                    
//                    Divider().opacity(0.5)
//                    
//                    BMICalculatorView(currentUser: currentUser)
//                    
//                    Divider().opacity(0.5)
//                    
//                    UserHealthChart(currentUser: currentUser)
//                }
//            }
//            .navigationTitle("Profile")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    let request: NSFetchRequest<User> = User.fetchRequest()
//    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
//    
//    UserProfileView()
//        .environmentObject(sampleUser)
//        .environment(\.managedObjectContext, context)
//}

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
            ZStack {
                // MARK: - Premium Warm Light Background Canvas
                ZStack {
                    // Base Soft Off-White / Cream
                    Color(red: 0.96, green: 0.95, blue: 0.93)
                        .ignoresSafeArea()
                    
                    // Top Light Gold Glow
                    RadialGradient(
                        colors: [
                            Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.40),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 400
                    )
                    .ignoresSafeArea()
                    
                    // Mid Warm Ambient Glow
                    RadialGradient(
                        colors: [
                            Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.30),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 500
                    )
                    .ignoresSafeArea()
                }
                
                // MARK: - Original View Layout
                ScrollView {
                    
                    Text("Profile")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.12))
                        .tracking(0.5)
                    
                    VStack(spacing: 30) {
                        
                        UserHeaderCardView(user: currentUser)
                        
                        Divider().opacity(0.5)
                        
                        UserInformationCardView(user: currentUser)
                        
                        Divider().opacity(0.5)
                        
                        EmergencyContactCardView(user: currentUser)
                        
                        Divider().opacity(0.5)
                        
                        InsuranceDetailsCardView(user: currentUser)
                        
                        Divider().opacity(0.5)
                        
                        BMICalculatorView(currentUser: currentUser)
                        
                        Divider().opacity(0.5)
                        
                        UserHealthChart(currentUser: currentUser)
                    }
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    
    return UserProfileView()
        .environmentObject(sampleUser)
        .environment(\.managedObjectContext, context)
}
