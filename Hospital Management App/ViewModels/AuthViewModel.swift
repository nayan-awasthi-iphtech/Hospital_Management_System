////
////  AuthViewModel.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 30/07/26.

import SwiftUI
internal import CoreData
internal import Combine

class AuthViewModel: ObservableObject {
    
    @Published var name:String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var phone: String = ""
    
    @Published var errorMessage: String?
    @Published var isProfileComplete: Bool = false
    @Published var showErrorAlert: Bool = false
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext){
        self.context = context
    }
    
    func signUp(userViewModel: UserViewModel? = nil)-> Bool {
        let cleanEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanName.isEmpty, !cleanEmail.isEmpty, !cleanPassword.isEmpty, !phone.isEmpty else {
            showError("Please enter all the details correctly before signing")
            return false
        }
        
        guard cleanPassword.count >= 6 else {
            showError("Password must be at least 6 characters")
            return false
        }
        
        if fetchUser(by: cleanEmail) != nil {
            showError("User is already registered with the given mail")
            return false
        }
        
        let newUserID = UUID()
        let newUser = User(context: context)
        newUser.id = newUserID
        newUser.name = cleanName
        newUser.email = cleanEmail
        newUser.password = cleanPassword
        newUser.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            try context.save()
            SessionManager.shared.currentUserID = newUserID.uuidString
            clearInputs()
            self.isProfileComplete = true
            print("User created successfully: \(String(describing: newUser))")
            return true
        } catch {
            errorMessage = "Failed to create user. Please try again."
            print("User signing error is coming: \(error.localizedDescription)")
            return false
        }
    }
    
    func login(userViewModel: UserViewModel? = nil) -> Bool {
        let cleanEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !email.isEmpty, !password.isEmpty else {
            showError("Please enter the correct details")
            return false
        }
        
        guard let existingUser = fetchUser(by: cleanEmail) else {
            showError("No account found with this email.")
            return false
        }
        
        if existingUser.password == cleanPassword {
            guard let userID = existingUser.id else {
                showError("User record error. Please try again.")
                return false
            }
            
            SessionManager.shared.currentUserID = userID.uuidString
            
            if isAnyDetailMissing(for: existingUser){
                self.isProfileComplete = true
            }
            clearInputs()
            print("User logged in successfuly \(existingUser)")
            return true
        } else {
            showError("Incorrect password. Please try again.")
            return false
        }
        
    }
    
    func updateProfileDetails(
        bloodGroup: String,
        allergies: String,
        emergencyContact: Int32,
        insuranceDetails: String,
        policyId: String,
        address: String,
        gender: String,
        height: String,
        weight: String,
        dob: Date
    ) -> Bool {
        
        guard let activeUser = SessionManager.shared.getActiveUser(in:context) else {
            showError("No active user session found.")
            return false
        }
        
        activeUser.bloodGroup = bloodGroup
        activeUser.allergies = allergies
        activeUser.emergencyContact = emergencyContact
        activeUser.insuranceDetails = insuranceDetails
        activeUser.policyId = policyId
        activeUser.address = address
        activeUser.gender = gender
        activeUser.height = height
        activeUser.weight = weight
        activeUser.dob = dob
        
        do {
            try context.save()
            self.isProfileComplete = false
            return true
        } catch {
            errorMessage = "Failed to update profile details. Please try again."
            print("Profile Update Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func logout(userViewModel: UserViewModel? = nil){
        SessionManager.shared.logout()
        clearInputs()
    }
    
    func fetchUser(by email: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
    private func isAnyDetailMissing(for user: User) -> Bool {
        return user.bloodGroup == nil || user.bloodGroup?.isEmpty == true ||
        user.allergies == nil ||
        user.insuranceDetails == nil || user.insuranceDetails?.isEmpty == true ||
        user.policyId == nil || user.policyId?.isEmpty == true ||
        user.address == nil || user.address?.isEmpty == true ||
        user.gender == nil || user.gender?.isEmpty == true ||
        user.height == nil || user.height?.isEmpty == true ||
        user.weight == nil || user.weight?.isEmpty == true ||
        user.emergencyContact == 0 ||
        user.dob == nil
    }
    
    func showError(_ text: String){
        self.errorMessage = text
        self.showErrorAlert = true
    }
    
    func clearInputs(){
        self.name = ""
        self.email = ""
        self.password = ""
        self.password = ""
        self.phone = ""
        self.errorMessage = nil
        self.showErrorAlert = false
    }
}
