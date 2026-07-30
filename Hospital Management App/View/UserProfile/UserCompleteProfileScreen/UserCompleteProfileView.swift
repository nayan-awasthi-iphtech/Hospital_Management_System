//
//  UserCompleteProfileView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 30/07/26.
//

import SwiftUI
internal import CoreData

struct UserCompleteProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var userViewModel = UserViewModel()
    @StateObject private var session = SessionManager.shared
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var bloodGroup: String = "A+"
    @State private var dob: Date = Date()
    @State private var gender: String = "Male"
    @State private var emergencyContact: Int32
    @State private var insuranceDetails: String = ""
    @State private var policyId: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var address: String = ""
    @State private var allergies: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSuccessAlert: Bool = false
    
    let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    let genders = ["Male", "Female", "Other"]
    
    private var currentUser: User? {
        userViewModel.currentUser ?? session.getActiveUser(in: viewContext)
    }
    
    var body: some View {
        NavigationStack{
            Form{
                // Header
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Medical Profile")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Fill in your complete details for better healthcare assistance.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                // Basic Details
                Section(header: Text("Basic Information")) {
                    HStack {
                        Text("Name")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Full Name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Email")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(email)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Phone")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("10-digit Phone", text: $phone)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    DatePicker("Date of Birth", selection: $dob, in: ...Date(), displayedComponents: .date)
                    
                    HStack {
                        Text("Address")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Street address, City", text: $address)
                            .multilineTextAlignment(.trailing)
                    }
                }
                // Health and Vitals
                Section(header: Text("Health & Medical Details")) {
                    Picker("Blood Group", selection: $bloodGroup) {
                        ForEach(bloodGroups, id: \.self) { group in
                            Text(group).tag(group)
                        }
                    }
                    
                    HStack {
                        Text("Height (cm)")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("e.g. 175", text: $height)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Weight (kg)")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("e.g. 70", text: $weight)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Allergies")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("e.g. Peanuts, Penicillin", text: $allergies)
                            .multilineTextAlignment(.trailing)
                    }
                }
                // Emergency and Insurance
                Section(header: Text("Emergency & Insurance")) {
                    HStack {
                        Text("Emergency Phone")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Emergency Contact", value: $emergencyContact, format: .number)
                            .keyboardType(.phonePad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Insurance Provider")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Provider Name", text: $insuranceDetails)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Policy ID")
                            .foregroundColor(.secondary)
                        Spacer()
                        TextField("Policy Number", text: $policyId)
                            .multilineTextAlignment(.trailing)
                    }
                }
                // Save Action
                Section {
                    Button(action: saveProfile) {
                        HStack {
                            Spacer()
                            Text("Save Profile")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(height: 44)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    
                }
                .alert(isSuccessAlert ? "Success": "Validation Error", isPresented: $showAlert){
                    Button("OK"){
                        if isSuccessAlert {
                            dismiss()
                        }
                    }
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    private func loadExistenceUserData() {
        guard let user = currentUser else { return }
        
        self.name = user.name ?? ""
        self.email = user.email ?? ""
        self.phone = user.phone ?? ""
        self.bloodGroup = (user.bloodGroup?.isEmpty == false) ? user.bloodGroup! : "A+"
        self.gender = (user.gender?.isEmpty == false) ? user.gender! : "Male"
        self.address = user.address ?? ""
        self.height = user.height ?? ""
        self.weight = user.weight ?? ""
        self.allergies = user.allergies ?? ""
        self.insuranceDetails = user.insuranceDetails ?? ""
        self.policyId = user.policyId ?? ""
        self.emergencyContact = user.emergencyContact
        if let userDOB = user.dob {
            self.dob = userDOB
        }
    }
    private func saveProfile(){
        guard let user = currentUser else {
            alertMessage = "User session not found"
            isSuccessAlert = false
            showAlert = true
            return
        }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            alertMessage = "PLease enter your full name"
            isSuccessAlert = false
            showAlert = true
            return
        }
        
        user.name = trimmedName
        user.phone = phone
        user.bloodGroup = bloodGroup
        user.gender = gender
        user.dob = dob
        user.address = address
        user.height = height
        user.weight = weight
        user.allergies = allergies
        user.insuranceDetails = insuranceDetails
        user.policyId = policyId
        user.emergencyContact = emergencyContact
        
        do {
            try viewContext.save()
            print("✅ [CompleteProfileView] Profile updated successfully for: \(trimmedName)")
            alertMessage = "Your profile details have been saved successfully!"
            isSuccessAlert = true
            showAlert = true
        } catch {
            print("❌ [CompleteProfileView] Failed to save profile: \(error.localizedDescription)")
            alertMessage = "Failed to save details: \(error.localizedDescription)"
            isSuccessAlert = false
            showAlert = true        }
    }
}

//
//#Preview {
//    UserCompleteProfileView()
//        .environmentObject(UserViewModel())
//}
