import SwiftUI
internal import CoreData

struct UserCompleteProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var session = SessionManager.shared
    
    @State private var bloodGroup: String = "A+"
    @State private var dob: Date = Date()
    @State private var gender: String = "Male"
    @State private var emergencyContact: String = ""
    @State private var insuranceDetails: String = ""
    @State private var policyId: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var address: String = ""
    @State private var allergies: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSuccessAlert: Bool = false
    
    @State private var profileImageData: Data? = nil
    
    private var isBloodGroupMissing: Bool {
        currentUser?.bloodGroup?.isEmpty ?? true
    }
    private var isDobMissing: Bool {
        currentUser?.dob == nil
    }
    private var isGenderMissing: Bool {
        currentUser?.gender?.isEmpty ?? true
    }
    private var isAddressMissing: Bool {
        currentUser?.address?.isEmpty ?? true
    }
    private var isHeightMissing: Bool {
        currentUser?.height?.isEmpty ?? true
    }
    private var isWeightMissing: Bool {
        currentUser?.weight?.isEmpty ?? true
    }
    private var isAllergiesMissing: Bool {
        currentUser?.allergies?.isEmpty ?? true
    }
    private var isEmergencyContactMissing: Bool {
        currentUser?.emergencyContact?.isEmpty ?? true
    }
    private var isInsuranceMissing: Bool {
        (currentUser?.insuranceDetails?.isEmpty ?? true) || (currentUser?.policyId?.isEmpty ?? true)
    }
    
    let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    let genders = ["Male", "Female", "Other"]
    
    private var currentUser: User? {
        userViewModel.currentUser ?? session.getActiveUser(in: viewContext)
    }
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Header Block
                    VStack(spacing: 12) {
                        VStack(spacing: 4) {
                            Text("Patient Profile")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Complete your details to personalize your healthcare experience")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            ZStack {
                                ImagePicker(selectedImageData: $profileImageData)
                            }
                        }
                    }
                    .padding(.top, 12)
                    
                    // Personal Information Card
                    if isBloodGroupMissing || isGenderMissing || isDobMissing || isAddressMissing {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Personal Details", systemImage: "person.fill")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            VStack(spacing: 14) {
                                if isBloodGroupMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Blood Group")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Picker("Blood Group", selection: $bloodGroup) {
                                            ForEach(bloodGroups, id: \.self) { group in
                                                Text(group).tag(group)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.cardBackground)
                                        .cornerRadius(10)
                                    }
                                }
                                
                                if isGenderMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Gender")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Picker("Gender", selection: $gender) {
                                            ForEach(genders, id: \.self) { item in
                                                Text(item).tag(item)
                                            }
                                        }
                                        .pickerStyle(.segmented)
                                    }
                                }
                                
                                if isDobMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Date of Birth")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        DatePicker("", selection: $dob, in: ...Date(), displayedComponents: .date)
                                            .labelsHidden()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                if isAddressMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Address")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("Enter street address, city, zip code", text: $address)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.cardBackground.opacity(0.65))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                    
                    // Health & Vitals Card
                    if isHeightMissing || isWeightMissing || isAllergiesMissing {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Health & Vitals", systemImage: "heart.fill")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            VStack(spacing: 14) {
                                if isHeightMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Height (cm)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("e.g. 175", text: $height)
                                            .keyboardType(.numberPad)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                if isWeightMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Weight (kg)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("e.g. 70", text: $weight)
                                            .keyboardType(.numberPad)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                if isAllergiesMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Allergies")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("e.g. Peanuts, Penicillin (or 'None')", text: $allergies)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.cardBackground.opacity(0.65))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                    
                    // Emergency & Insurance Card
                    if isEmergencyContactMissing || isInsuranceMissing {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Emergency & Insurance", systemImage: "shield.fill")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            VStack(spacing: 14) {
                                if isEmergencyContactMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Emergency Contact Phone")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("e.g. 9876543210", text: $emergencyContact)
                                            .keyboardType(.phonePad)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                if isInsuranceMissing {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Insurance Provider")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("Enter insurance provider name", text: $insuranceDetails)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Policy ID")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("Enter policy number or ID", text: $policyId)
                                            .padding(12)
                                            .background(Color.cardBackground)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.cardBackground.opacity(0.65))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                    
                    // Action Save Button
                    Button(action: saveProfile) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Profile")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(red: 0.30, green: 0.25, blue: 0.20))
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
            }
            .onAppear {
                loadExistenceUserData()
            }
            .alert(isSuccessAlert ? "Success" : "Validation Error", isPresented: $showAlert) {
                Button("OK") {
                    if isSuccessAlert {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func loadExistenceUserData() {
        guard let user = currentUser else { return }
        
        if let userBloodGroup = user.bloodGroup, !userBloodGroup.isEmpty {
            self.bloodGroup = userBloodGroup
        }
        if let userGender = user.gender, !userGender.isEmpty {
            self.gender = userGender
        }
        if let userDOB = user.dob {
            self.dob = userDOB
        }
        self.address = user.address ?? ""
        self.height = user.height ?? ""
        self.weight = user.weight ?? ""
        self.allergies = user.allergies ?? ""
        self.insuranceDetails = user.insuranceDetails ?? ""
        self.policyId = user.policyId ?? ""
        self.emergencyContact = user.emergencyContact ?? ""
    }
    
    private func saveProfile() {
        guard let user = currentUser else {
            alertMessage = "User session not found"
            isSuccessAlert = false
            showAlert = true
            return
        }
        
        if isBloodGroupMissing { user.bloodGroup = bloodGroup }
        if isGenderMissing { user.gender = gender }
        if isDobMissing { user.dob = dob }
        if isAddressMissing { user.address = address }
        
        if isHeightMissing { user.height = height }
        if isWeightMissing { user.weight = weight }
        if isAllergiesMissing { user.allergies = allergies }
        
        if isEmergencyContactMissing { user.emergencyContact = emergencyContact }
        if isInsuranceMissing {
            user.insuranceDetails = insuranceDetails
            user.policyId = policyId
        }
        
        if let newImageData = profileImageData {
            user.imageData = newImageData
        }
        
        do {
            try viewContext.save()
            userViewModel.fetchUser()
            print("✅ [CompleteProfileView] Profile updated successfully")
            alertMessage = "Your profile details have been saved successfully!"
            isSuccessAlert = true
            showAlert = true
        } catch {
            print("❌ [CompleteProfileView] Failed to save profile: \(error.localizedDescription)")
            alertMessage = "Failed to save details: \(error.localizedDescription)"
            isSuccessAlert = false
            showAlert = true
        }
    }
}

#Preview {
    UserCompleteProfileView()
        .environmentObject(UserViewModel())
}
