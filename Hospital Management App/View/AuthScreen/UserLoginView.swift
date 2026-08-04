//
//  UserLoginView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 30/07/26.
//

import SwiftUI
internal import CoreData

struct UserLoginView: View {
    
    @StateObject var viewModel = AuthViewModel()
    var onLoginSuccessful: () -> Void
    
    @State private var ShowRegistrationScreen: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                AppBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack(spacing: 24){
                        
                        VStack(spacing: 8){
                            ZStack {
                                // Soft glowing background circle/layer
                                Circle()
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(width: 80, height: 80)
                                
                                // Main SF Symbol Icon
                                Image(systemName: "cross.case.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .blue.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .frame(width: 96, height: 96)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.cardBackground.opacity(0.8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .strokeBorder(Color.orange.opacity(0.2), lineWidth: 1.5)
                                    )
                                    .shadow(color: Color.blue.opacity(0.5), radius: 12, x: 0, y: 6)
                            )
                            .padding(.bottom, 8)
                            
                            Text("Welcome Back")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Log in to access your appointments and health records.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16){
                            VStack(alignment: .leading, spacing: 6){
                                Text("Email Address")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                
                                HStack{
                                    Image(systemName: "envelope.fill")
                                        .foregroundStyle(.gray)
                                    TextField("", text: $viewModel.email, prompt: Text("Enter your email").foregroundColor(Color.secondaryText.opacity(0.7)))
                                        .foregroundColor(Color.primaryText)
                                        .keyboardType(.emailAddress)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                }
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                            }
                            VStack(alignment: .leading, spacing: 6){
                                Text("Password")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                
                                HStack{
                                    Image(systemName: "lock")
                                        .foregroundStyle(.gray)
                                    TextField("", text: $viewModel.password, prompt: Text("Enter your password").foregroundColor(Color.secondaryText.opacity(0.7)))
                                        .foregroundColor(Color.primaryText)
                                }
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        Button(action: {
                            if viewModel.login(){
                                onLoginSuccessful()
                            }
                        }) {
                            Text("Log In")
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
                            Text("Don't have a account?")
                                .foregroundStyle(.secondary)
                            
                            Button("Sign Up"){
                                ShowRegistrationScreen = true
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                        }
                        .font(.subheadline)
                        .padding(.bottom, 20)
                    }
                }
                .sheet(isPresented: $ShowRegistrationScreen){
                    withAnimation{
                        UserSignupView{
                            onLoginSuccessful()
                        }
                    }
                }
                .alert("Registration Error", isPresented: $viewModel.showErrorAlert){
                    Button("OK", role: .cancel){}
                } message: {
                    Text(viewModel.errorMessage ?? "An unkown error occured")
                }
            }
        }
    }
}

#Preview {
    UserLoginView(onLoginSuccessful: {})
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
