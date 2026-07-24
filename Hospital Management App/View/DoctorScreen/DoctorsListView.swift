////
////  DoctorsListView.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 16/07/26.
////
//
//import SwiftUI
//internal import CoreData
//
//struct DoctorsListView: View {
//    
//    @Environment(\.managedObjectContext) var viewContext
//    
//    @State private var searchText: String = ""
//    @State private var selectedCategory: String = "All"
//    
//    @Binding var selectedTab:Int
//    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
//        animation: .default)
//    
//    var users: FetchedResults<User>
//    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Doctor.name, ascending: true)],
//        animation: .default)
//    
//    var doctors: FetchedResults<Doctor>
//    
//    var uniqueCategories: [String]{
//        let departments = Set(doctors.compactMap{ doctor in doctor.department})
//        return ["All"] + departments.sorted()
//    }
//    
//      var filteredDoctors: [Doctor] {
//            if searchText.isEmpty && selectedCategory == "All" {
//                return Array(doctors)
//            }
//            
//            if searchText.isEmpty && selectedCategory != "All" {
//                return doctors.filter { doctor in
//                    doctor.department?.localizedCaseInsensitiveContains(selectedCategory) ?? false
//                }
//            }
//
//            return doctors.filter { doctor in
//                let matchesCategory = selectedCategory == "All" || (doctor.department?.localizedCaseInsensitiveContains(selectedCategory) ?? false)
//                
//                let matchesSearch = doctor.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
//                                    doctor.department?.localizedCaseInsensitiveContains(searchText) ?? false
//                
//                return matchesCategory && matchesSearch
//            }
//        }
//    
//    var body: some View {
//        NavigationStack {
//            ZStack{
//                Color(.systemGroupedBackground)
//                    .ignoresSafeArea()
//                
//                ScrollView{
//                    VStack(spacing:16){
//                        
//                        SpecialtyFilterView(selectedCategory: $selectedCategory, categories: uniqueCategories)
//                        
//                        if !filteredDoctors.isEmpty {
//                            VStack(spacing:12){
//                                ForEach(filteredDoctors, id: \.objectID) { doctor in
//                                    if let currentUser = users.first {
//                                        NavigationLink(destination: DoctorDetailScreen(doctor: doctor, user: currentUser,selectedTab: $selectedTab)){
//                                            DoctorRowCard(doctor: doctor)
//                                        }
//                                        .buttonStyle(PlainButtonStyle())
//                                    } else {
//                                        // Fallback UI when no user is available
//                                        DoctorRowCard(doctor: doctor)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 20)
//                        } else {
//                            ContentUnavailableView(
//                                "No Doctors Available",
//                                systemImage: "cross.case.fill",
//                                description: Text("Try checking your database")
//                            )
//                            .padding(.top, 10)
//                        }
//                    }
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Find Doctors")
//                        .font(.system(size: 34, weight: .bold)) 
//                        .foregroundColor(.primary)
//                }
//            }
//            .searchable(
//                text: $searchText,
//                placement: .navigationBarDrawer(displayMode: .always),
//                prompt: "Search doctors by name or specialty"
//            )
//        }
//    }
//}
////
////#Preview {
////    DoctorsListView()
////        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
////}


//
//  DoctorsListView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

import SwiftUI
internal import CoreData

struct DoctorsListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    
    @Binding var selectedTab: Int
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default)
    
    var users: FetchedResults<User>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Doctor.name, ascending: true)],
        animation: .default)
    
    var doctors: FetchedResults<Doctor>
    
    var uniqueCategories: [String] {
        let departments = Set(doctors.compactMap { doctor in doctor.department })
        return ["All"] + departments.sorted()
    }
    
    var filteredDoctors: [Doctor] {
        if searchText.isEmpty && selectedCategory == "All" {
            return Array(doctors)
        }
        
        if searchText.isEmpty && selectedCategory != "All" {
            return doctors.filter { doctor in
                doctor.department?.localizedCaseInsensitiveContains(selectedCategory) ?? false
            }
        }

        return doctors.filter { doctor in
            let matchesCategory = selectedCategory == "All" || (doctor.department?.localizedCaseInsensitiveContains(selectedCategory) ?? false)
            
            let matchesSearch = doctor.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                                doctor.department?.localizedCaseInsensitiveContains(searchText) ?? false
            
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        SpecialtyFilterView(selectedCategory: $selectedCategory, categories: uniqueCategories)
                        
                        if !filteredDoctors.isEmpty {
                            VStack(spacing: 12) {
                                ForEach(filteredDoctors, id: \.objectID) { doctor in
                                    if let currentUser = users.first {
                                        NavigationLink(destination: DoctorDetailScreen(doctor: doctor, user: currentUser, selectedTab: $selectedTab)) {
                                            DoctorRowCard(doctor: doctor)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    } else {
                                        // Fallback UI when no user is available
                                        DoctorRowCard(doctor: doctor)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        } else {
                            ContentUnavailableView(
                                "No Doctors Available",
                                systemImage: "cross.case.fill",
                                description: Text("Try checking your database")
                            )
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Find Doctors")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.12))
                        .tracking(0.5)
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search doctors by name or specialty"
            )
        }
    }
}

//#Preview {
//    DoctorsListView(selectedTab: .constant(0))
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
