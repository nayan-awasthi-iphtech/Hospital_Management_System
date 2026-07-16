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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Doctor.name, ascending: true)],
        animation: .default)
    
    var doctors: FetchedResults<Doctor>
    
    var uniqueCategories: [String]{
        let departments = Set(doctors.compactMap{ doctor in doctor.department})
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
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack(spacing:16){
                        
                        SpecialtyFilterView(selectedCategory: $selectedCategory, categories: uniqueCategories)
                        
                        if !filteredDoctors.isEmpty {
                            VStack(spacing:12){
                                ForEach(filteredDoctors, id: \.objectID) { doctor in
                                    NavigationLink(destination: DoctorDetailScreen(doctor: doctor)){
                                        DoctorRowCard(doctor: doctor)
                                    }
                                    .buttonStyle(PlainButtonStyle())
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
                        .font(.system(size: 34, weight: .bold)) 
                        .foregroundColor(.primary)
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

#Preview {
    DoctorsListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
