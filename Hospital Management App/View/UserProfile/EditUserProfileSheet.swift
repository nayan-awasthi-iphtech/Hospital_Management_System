////
////  EditUserProfileSheet.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 27/07/26.

import SwiftUI
internal import CoreData

struct EditUserProfileSheet: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: UserViewModel
    @StateObject private var session = SessionManager.shared
    
    @State private var profileImageData: Data? = nil
    
    // Fetch the active user entity
    private var currentUser: User? {
        viewModel.currentUser ?? session.getActiveUser(in: viewContext)
    }
    
    // Check if fields were already completed by the user
    private var isNameCompleted: Bool {
        !(currentUser?.name?.isEmpty ?? true)
    }
    
    private var isWeightCompleted: Bool {
        !(currentUser?.weight?.isEmpty ?? true)
    }
    
    private var isEmergencyContactCompleted: Bool {
        !(currentUser?.emergencyContact?.isEmpty ?? true)
    }
    
    private var isInsuranceProviderCompleted: Bool {
        !(currentUser?.insuranceDetails?.isEmpty ?? true)
    }
    
    private var isPolicyIdCompleted: Bool {
        !(currentUser?.policyId?.isEmpty ?? true)
    }
    
    // Assuming you have coverage stored or checked similarly
    private var isCoverageCompleted: Bool {
        // Adjust according to your CoreData attribute name if coverage exists on User model
        !(currentUser?.insuranceDetails?.isEmpty ?? true)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                
                Form {
                    
                    Section {
                        ImagePicker(selectedImageData: $profileImageData)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowBackground(Color.clear)
                    
                    // Personal Info Section
                    if isNameCompleted || isWeightCompleted {
                        Section(header: Text("Personal Info")) {
                            VStack(spacing: 20) {
                                if isNameCompleted {
                                    HStack {
                                        Text("Name")
                                            .frame(width: 100, alignment: .leading)
                                        TextField("Enter name", text: $viewModel.editName)
                                    }
                                }
                                
                                if isNameCompleted && isWeightCompleted {
                                    Divider()
                                }
                                
                                if isWeightCompleted {
                                    HStack {
                                        Text("Weight")
                                            .frame(width: 100, alignment: .leading)
                                        TextField("Enter weight", text: $viewModel.editWeight)
                                            .keyboardType(.numberPad)
                                    }
                                }
                            }
                            .listRowBackground(Color.cardBackground.opacity(0.42))
                        }
                    }
                    
                    // Emergency Contact Section
                    if isEmergencyContactCompleted {
                        Section(header: Text("Emergency Contact")) {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Contact No.")
                                        .frame(width: 100, alignment: .leading)
                                    TextField("Enter emergency contact no.", text: $viewModel.editEmergencyContact)
                                        .keyboardType(.phonePad)
                                }
                            }
                            .listRowBackground(Color.cardBackground.opacity(0.42))
                        }
                    }
                    
                    // Insurance Details Section
                    if isInsuranceProviderCompleted || isPolicyIdCompleted {
                        Section(header: Text("Insurance Details")) {
                            VStack(spacing: 20) {
                                if isInsuranceProviderCompleted {
                                    HStack {
                                        Text("Provider")
                                            .frame(width: 100, alignment: .leading)
                                        TextField("Enter policy provider name", text: $viewModel.editInsuranceDetail)
                                    }
                                }
                                
                                if isInsuranceProviderCompleted && isPolicyIdCompleted {
                                    Divider()
                                }
                                
                                if isPolicyIdCompleted {
                                    HStack {
                                        Text("Policy No.")
                                            .frame(width: 100, alignment: .leading)
                                        TextField("Enter policy no.", text: $viewModel.editInsurancePolicy)
                                    }
                                }
                                
                                if isCoverageCompleted {
                                    Divider()
                                    HStack {
                                        Text("Coverage")
                                            .frame(width: 100, alignment: .leading)
                                        TextField("Enter policy coverage", text: $viewModel.editInsuranceConverage)
                                    }
                                }
                            }
                            .listRowBackground(Color.cardBackground.opacity(0.42))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewModel.cancelEdits()
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if viewModel.saveUserEdits() {
                                dismiss()
                            }
                        }
                        .disabled(!viewModel.isformValid)
                    }
                }
                .onAppear{
                    if let saveData = currentUser?.imageData {
                        profileImageData = saveData
                    }
                }
            }
        }
    }
}

#Preview {
    EditUserProfileSheet()
        .environmentObject(UserViewModel())
}
