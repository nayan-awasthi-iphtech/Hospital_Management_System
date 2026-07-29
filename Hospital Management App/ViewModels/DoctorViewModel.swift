//
//  DoctorViewModel.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 28/07/26.
//

import Foundation
internal import CoreData
internal import Combine

class DoctorViewModel: ObservableObject {
    
    @Published var doctors: [Doctor] = []
    
    @Published var selectedDoctor: Doctor?
    
    @Published var isShowingSheet: Bool = false
    
    @Published var editname: String = ""
    @Published var editExperience: Int16? = nil
    @Published var editQualification: String = ""
    @Published var editAbout: String = ""
    @Published var editDepartment: String = ""
    @Published var editImageData: Data? = nil
    @Published var isError: String?
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext){
        self.context = context
        fetchDoctors()
    }
    
    func fetchDoctors(){
        
        let request: NSFetchRequest<Doctor> = Doctor.fetchRequest()
        
        let SortDescriptor = NSSortDescriptor(keyPath: \Doctor.name, ascending: true)
        
        request.sortDescriptors = [SortDescriptor]
        
        do{
            self.doctors=[]
            self.doctors = try context.fetch(request)
        } catch {
            self.isError = "Failed to load doctors: \(error.localizedDescription)"
            print("error while fetching the doctors: \(error.localizedDescription)")
        }
    }
    
    func updateDoctorFields(for doctor: Doctor){
        self.selectedDoctor = doctor
        self.editname = doctor.name ?? ""
        self.editExperience = doctor.experienceYears
        self.editQualification = doctor.qualification ?? ""
        self.editAbout = doctor.about ?? ""
        self.editImageData = nil
    }
    
    func addnewDoctorFields(){
        self.selectedDoctor = nil
        self.editname = ""
        self.editExperience = editExperience
        self.editQualification = ""
        self.editAbout = ""
        self.editDepartment = ""
        self.editImageData = nil
    }
    
    var isformValid: Bool {
        let trimmedName = editname.trimmingCharacters(in: .whitespaces)
        let trimmedQualification = editQualification.trimmingCharacters(in: .whitespaces)
        let trimmedAbout = editAbout.trimmingCharacters(in: .whitespaces)
        let trimmedDepartment = editDepartment.trimmingCharacters(in: .whitespaces)
        return !trimmedName.isEmpty &&
               !trimmedQualification.isEmpty &&
               !trimmedAbout.isEmpty &&
               !trimmedDepartment.isEmpty
    }
    
    func saveChanges() -> Bool {
        guard isformValid else {
            isError = "Please fill in all the fields correctly"
            return false
        }
        
        let doctorToSave = selectedDoctor ?? Doctor(context: context)
        
        doctorToSave.name = editname
        doctorToSave.experienceYears = editExperience ?? 0
        doctorToSave.qualification = editQualification
        doctorToSave.about = editAbout
        doctorToSave.department = editDepartment
        
        if selectedDoctor == nil {
            doctorToSave.imageData = editImageData
        }
        
        do {
            try context.save()
            fetchDoctors()
            return true
        } catch {
            self.isError = "failed to save doctor \(error.localizedDescription)"
            print("error in saving or updating doctor: \(error.localizedDescription)")
            return false
        }
    }
    
    func cancelEdits(){
        if context.hasChanges {
            context.rollback()
        }
        if let doctor = selectedDoctor{
            updateDoctorFields(for: doctor)
        }
    }
    
    func deleteDoctor(_ doctor: Doctor){
        context.delete(doctor)
        
        do {
            try context.save()
            
            if let index = doctors.firstIndex(where: {$0.objectID == doctor.objectID}){
                doctors.remove(at: index)
                fetchDoctors()
            }
        } catch {
            print("Failed to delete doctor: \(error.localizedDescription)()")
        }
    }
}

