//
//  AddNewDoctorSheet.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 24/07/26.
//

import SwiftUI
import PhotosUI
internal import CoreData

struct AddDoctorSheetView: View {
    
    @EnvironmentObject var doctorViewModel: DoctorViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Form States (UI Inputs)
    //    @State private var doctorName: String = ""
    //    @State private var selectedDepartment: String = "General Medicine"
    //    @State private var yearsOfExperience: Int16? = nil
    //    @State private var doctorBio: String = ""
    //    @State private var qualification : String = ""
    
    // Photo Picker States
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedUIImage: UIImage? = nil
    
    @State private var errorMesage: String? = nil
    @State private var showerrorMessage: Bool = false
    
    // Department Options
    private let departments = [
        "General Medicine",
        "Cardiology",
        "Dermatology",
        "Neurology",
        "Pediatrics",
        "Orthopedics",
        "Psychiatry"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 12) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                ZStack(alignment: .bottomTrailing) {
                                    if let selectedUIImage = selectedUIImage {
                                        Image(uiImage: selectedUIImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                                    } else {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 110, height: 110)
                                            .overlay(
                                                Image(systemName: "person.crop.circle.badge.plus")
                                                    .font(.system(size: 38))
                                                    .foregroundColor(.gray)
                                            )
                                    }
                                    
                                    // Camera Edit Badge
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .padding(.trailing, 2)
                                        .padding(.bottom, 2)
                                }
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        self.doctorViewModel.editImageData = data
                                        self.selectedUIImage = uiImage
                                    }
                                }
                            }
                            
                            Text(selectedUIImage == nil ? "Tap to add photo" : "Change Photo")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // Full Name
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Doctor Name")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                
                                TextField("e.g. Dr. Sarah Jenkins", text: $doctorViewModel.editname)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            
                            // Department Picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Specialty / Department")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                
                                Menu {
                                    ForEach(departments, id: \.self) { dept in
                                        Button(dept) {
                                            doctorViewModel.editDepartment = dept.trimmingCharacters(in: .whitespacesAndNewlines)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(doctorViewModel.editDepartment.isEmpty ? "Select Department" : doctorViewModel.editDepartment)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Experience (Years)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                
                                TextField("e.g. 8", value: $doctorViewModel.editExperience, format: .number)
                                    .keyboardType(.numberPad)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Qualification")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                
                                TextField("B.Pharma", text: $doctorViewModel.editQualification)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("About Doctor")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                
                                TextEditor(text: $doctorViewModel.editAbout)
                                    .frame(height: 90)
                                    .padding(6)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            if doctorViewModel.saveChanges(){
                                dismiss()
                            }
                        }) {
                            Text("Save Doctor")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.blue)
                                .cornerRadius(16)
                                .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .disabled(!doctorViewModel.isformValid)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Add New Doctor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        doctorViewModel.cancelEdits()
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }
    
}

#Preview("Add Doctor Sheet") {
    AddDoctorSheetView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
