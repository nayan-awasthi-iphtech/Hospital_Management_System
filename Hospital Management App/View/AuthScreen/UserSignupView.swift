//
//  UserSignupView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 30/07/26.
//

import SwiftUI
internal import CoreData

struct UserSignupView: View {
    
    @StateObject var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
        var onRegisrationSuccess: () -> Void
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 24){
                    
                    VStack(spacing: 8){
                        Image(systemName: "cross.case.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.blue)
                            .padding(.bottom, 8)
                        
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Sign up to book Appointments and track your health")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16){
                        VStack(alignment: .leading, spacing: 6){
                            Text("Full Name")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            HStack{
                                Image(systemName: "person")
                                    .foregroundStyle(.gray)
                                TextField("Enter your full Name", text: $viewModel.name)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 6){
                            Text("Email Address")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            HStack{
                                Image(systemName: "at")
                                    .foregroundStyle(.gray)
                                TextField("Enter your email", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                        }
                        VStack(alignment: .leading, spacing: 6){
                            Text("Contact No.")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            HStack{
                                Image(systemName: "phone")
                                    .foregroundStyle(.gray)
                                TextField("Enter your phone number", text: $viewModel.phone)
                                    .keyboardType(.phonePad)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 6){
                            Text("Password")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            HStack{
                                Image(systemName: "lock")
                                    .foregroundStyle(.gray)
                                TextField("Enter your password", text: $viewModel.password)
                                    .keyboardType(.phonePad)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    Button(action: {
                        if viewModel.signUp(){
                            onRegisrationSuccess()
                            dismiss()
                        }
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.blue)
                            .cornerRadius(14)
                            .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    HStack{
                        Text("Already have a account?")
                            .foregroundStyle(.secondary)
                        
                        Button("Log In"){
                            dismiss()
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    }
                    .font(.subheadline)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .alert("Registration Error", isPresented: $viewModel.showErrorAlert){
                Button("OK", role: .cancel){}
            } message: {
                Text(viewModel.errorMessage ?? "An unkown error occured")
            }
        }
    }
}

#Preview {
    UserSignupView(onRegisrationSuccess: {})
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
