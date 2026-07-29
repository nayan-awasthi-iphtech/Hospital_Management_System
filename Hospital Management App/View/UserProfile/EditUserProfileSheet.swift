//
//  EditUserProfileSheet.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 27/07/26.
//

import SwiftUI
internal import CoreData

struct EditUserProfileSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                
                Form {
                    Section(header: Text("Personal Info")) {
                        VStack(spacing:20){
                            HStack {
                                Text("Name")
                                    .frame(width: 100, alignment: .leading)
                                TextField("Enter name", text: $viewModel.editName)
                            }
                            
                            Divider()
                            
                            HStack(){
                                Text("Weight")
                                    .frame(width: 100, alignment: .leading)
                                TextField("Enter weight", text: $viewModel.editWeight)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.42))
                    }
                    
                    Section(header: Text("Emergency Contact")) {
                        VStack(spacing:20){
                            HStack {
                                Text("Contact No.")
                                    .frame(width: 100, alignment: .leading)
                                TextField("Enter emergency contact no.", value: $viewModel.editEmergencyContact, format: .number.grouping(.never))
                                    .keyboardType(.numberPad)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.42))
                    }
                    
                    Section(header: Text("Insurance Details")) {
                        VStack(spacing:20){
                            HStack {
                                Text("Provider")
                                    .frame(width: 100, alignment: .leading)
                                TextField("Enter policy provider name", text: $viewModel.editInsuranceDetail)
                            }
                            
                            HStack {
                                Text("Policy No.")
                                    .frame(width: 100, alignment: .leading)
                                TextField("Enter policy no.", text: $viewModel.editInsurancePolicy)
                            }
                            HStack {
                                Text("Coverage")
                                    .frame(width: 100, alignment: .leading)
                                TextField("Enter policy coverage", text: $viewModel.editInsuranceConverage)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.42))
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
                            if viewModel.saveUserEdits(){
                                dismiss()
                            }
                        }
                        .disabled(!viewModel.isformValid)
                    }
                }
            }
        }
    }
}

#Preview {
    EditUserProfileSheet()
}
