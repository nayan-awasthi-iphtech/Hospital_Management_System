import SwiftUI
internal import CoreData

struct DoctorsListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    
    @State private var showAddDoctorSheet: Bool = false
    
    @State private var doctorToDelete: Doctor?
    @State private var showDeleteAlert: Bool = false
    
    @Binding var selectedTab: Int
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Doctor.name, ascending: true)],
        animation: .default)
    var doctors: FetchedResults<Doctor>
    
    private var currentUser: User? {
        PersistenceController.shared.currentUser
    }
    
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
                // Background Layer
                Color(red: 0.96, green: 0.95, blue: 0.93)
                    .ignoresSafeArea()
                
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
                
                // Content Layout
                VStack(spacing: 0) {
                    
                    // Specialty Category Picker section
                    SpecialtyFilterView(selectedCategory: $selectedCategory, categories: uniqueCategories)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowSeparator(.hidden)
                    
                    // Main Doctors List
                    List {
                        if !filteredDoctors.isEmpty {
                            Section {
                                ForEach(filteredDoctors, id: \.objectID) { doctor in
                                    Group {
                                        if let user = currentUser {
                                            NavigationLink(destination: DoctorDetailScreen(doctor: doctor, user: user, selectedTab: $selectedTab)) {
                                                DoctorRowCard(doctor: doctor)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        } else {
                                            DoctorRowCard(doctor: doctor)
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                                    .listRowSeparator(.hidden)
                                }
                                .onDelete { indexSet in
                                    if let index = indexSet.first {
                                        doctorToDelete = filteredDoctors[index]
                                        showDeleteAlert = true
                                    }
                                }
                            }
                        } else {
                            Section {
                                ContentUnavailableView(
                                    "No Doctors Available",
                                    systemImage: "cross.case.fill",
                                    description: Text("Try checking your database")
                                )
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Find Doctors")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.12))
                        .tracking(0.5)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddDoctorSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search doctors by name or specialty"
            )
            .sheet(isPresented: $showAddDoctorSheet) {
                AddDoctorSheetView()
            }
            .alert("Delete Doctor", isPresented: $showDeleteAlert, presenting: doctorToDelete) { doctor in
                Button("Delete", role: .destructive) {
                    deleteDoctor(doctor)
                }
                
                Button("Cancel", role: .cancel) {
                    doctorToDelete = nil
                }
            } message: { doctor in
                Text("Are you sure you want to delete \(doctor.name ?? "this doctor")? This action cannot be undone.")
            }
        }
    }
    
    private func deleteDoctor(_ doctor: Doctor) {
        let doctorName = doctor.name ?? "Doctor"
        viewContext.delete(doctor)
        do {
            try viewContext.save()
            print("Data deleted successfully for \(doctorName)")
        } catch {
            print("Error while deleting the doctor: \(error.localizedDescription)")
        }
    }
}
