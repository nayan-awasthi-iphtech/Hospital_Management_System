//
//  UserViewModel.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 28/07/26.
//

import Foundation
internal import CoreData
internal import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    
    @Published var isshowEditSheet: Bool = false
    
    @Published var editName: String = ""
    @Published var editEmail: String = ""
    @Published var editPhone: String = ""
    @Published var editEmergencyContact: String = ""
    @Published var editInsuranceDetail: String = ""
    @Published var editInsurancePolicy: String = ""
    @Published var editInsuranceConverage: String = ""
    @Published var editWeight:String = ""
    @Published var errorMessage: String?
    @Published var edituserProfileImage: Data? = nil
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext){
        self.context = context
        fetchUser()
    }
    
    func fetchUser(){
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            if let user = SessionManager.shared.getActiveUser(in: context){
                self.currentUser = user
                if (user.user_medicine?.count ?? 0) == 0 {
                    Medicine.createMedicinesForUser(user, in: context)
                }
                updateUserFields(from: user)
            } else {
                print("No user found in coreData")
            }
        } catch {
            self.errorMessage = "Faile to load profile: \(error.localizedDescription)"
            print(error.localizedDescription)
        }
    }
    
    func updateUserFields(from user: User){
        self.editName = user.name ?? ""
        self.editEmail = user.email ?? ""
        self.editPhone = user.phone ?? ""
        self.editEmergencyContact = user.emergencyContact ?? ""
        self.editInsuranceDetail = user.insuranceDetails ?? ""
        self.editInsurancePolicy = user.policyId ?? ""
        self.editInsuranceConverage = user.coverage ?? ""
        self.editWeight = user.weight ?? ""
        self.edituserProfileImage = user.imageData
    }
    
    func clearUserFields() {
        self.editName = ""
        self.editEmail = ""
        self.editPhone = ""
        self.editEmergencyContact = ""
        self.editInsuranceDetail = ""
        self.editInsurancePolicy = ""
        self.editInsuranceConverage = ""
        self.editWeight = ""
        self.edituserProfileImage = nil
    }
    
    var isformValid: Bool {
        let trimmedName = editName.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = editEmail.trimmingCharacters(in: .whitespaces)
        return !trimmedName.isEmpty && (trimmedEmail.isEmpty || trimmedEmail.contains("@"))
    }
    
    func saveUserEdits() -> Bool {
        guard let user = currentUser else { return false }
        
        guard isformValid else {
            errorMessage = "Please enter a valid name and email."
            return false
        }
        
        user.name = editName
        user.email = editEmail
        user.phone = editPhone
        user.emergencyContact = editEmergencyContact
        user.insuranceDetails = editInsuranceDetail
        user.policyId = editInsurancePolicy
        user.coverage = editInsuranceConverage
        user.weight = editWeight
        user.imageData = edituserProfileImage
        
        do {
            try context.save()
            fetchUser()
            return true
        } catch {
            errorMessage = "Failed to save update: \(error.localizedDescription)"
            print("error in user update: \(error.localizedDescription)")
            return false
        }
    }
    
    
    func cancelEdits(){
        if context.hasChanges {
            context.rollback()
        }
        if let user = currentUser{
            updateUserFields(from: user)
        }
    }
    func logout() {
        SessionManager.shared.logout()
        self.currentUser = nil
        clearUserFields()
    }
}
