//
//  DummyData.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

internal import CoreData
import SwiftUI

extension User {
    static func UserDummyData(viewContext: NSManagedObjectContext){
        let names = ["John Doe", "Jane Smith", "Robert Chen", "Emily Rodriguez", "William Taylor"]
        let bloodGroups = ["O+", "A-", "B+", "AB+", "O-"]
        let diseases = ["Penicillin", "None", "Peanuts", "Sulfa Drugs", "None"]
        let insuranceDetailsPool = [
            "BlueShield Platinum PPO - Policy #BS-994821-X",
            "UnitedHealth Care Choice Plus - Policy #UH-883719-A",
            "Aetna Premium Health HMO - Policy #AE-441029-M",
            "Cigna Open Access Plus - Policy #CG-772911-B",
            "Humana Gold Value Plan - Policy #HU-110293-K"
        ]
        
        let emergencyContactsPool: [Int32] = [
            5550143,
            5550188,
            5550121,
            5550165,
            5550190
        ]
        
        for i in 0..<5 {
            let user = User(context: viewContext)
            user.name = names[i]
            user.id = UUID()
            user.bloodGroup = bloodGroups[i]
            user.diseases = diseases[i]
            user.emergencyContact = emergencyContactsPool[i]
            user.insuranceDetails = insuranceDetailsPool[i]
        }
        
        try? viewContext.save()
    }
}

extension Doctor {
    static func DoctorDummyData(viewContext:NSManagedObjectContext){
        let names = ["Dr. Alice Green", "Dr. Brian Patel", "Dr. Clara Oswald", "Dr. David Kim", "Dr. Elena Rostova"]
        let departments = ["Cardiology", "Pediatrics", "Neurology", "Orthopedics", "Dermatology"]
        let specialties = ["Heart Failure", "General Pediatrics", "Stroke Specialist", "Joint Replacement", "Cosmetic Dermatology"]
        
        
        for i in 0..<5 {
            let doctor = Doctor(context: viewContext)
            doctor.name = names[i]
            doctor.id = UUID()
            doctor.department = departments[i]
            doctor.specialty = specialties[i]
            if let uiImage = UIImage(named: "doctor\(i+1)"){
                doctor.imageData = uiImage.jpegData(compressionQuality: 0.8)
            }
        }
        
        try? viewContext.save()
    }
}


extension Appointment {
    static func ApppointmentDummyData(viewContext:NSManagedObjectContext){
        
        let users: [User] = (try? viewContext.fetch(User.fetchRequest())) ?? []
        let doctors: [Doctor] = (try? viewContext.fetch(Doctor.fetchRequest())) ?? []
        
        guard !users.isEmpty && !doctors.isEmpty else { return }
        
        
        let statuses = ["Scheduled", "Completed", "Scheduled", "Canceled", "Scheduled"]
        
        for i in 0..<5 {
            let appointment = Appointment(context: viewContext)
            appointment.status = statuses[i]
            appointment.id = UUID()
            appointment.appointment_user = users[i % users.count]
            appointment.appointment_doctor = doctors[i % doctors.count]
            
        }
        
        try? viewContext.save()
    }
}

extension Prescription {
    static func PrescriptionDummyData(viewContext:NSManagedObjectContext){
        
        let appointments = (try? viewContext.fetch(Appointment.fetchRequest())) ?? []
        let users = (try? viewContext.fetch(User.fetchRequest())) ?? []
        let doctors = (try? viewContext.fetch(Doctor.fetchRequest())) ?? []
        
        guard !appointments.isEmpty else { return }
        
        let medicines = ["Amoxicillin", "Lisinopril", "Ibuprofen", "Metformin", "Atorvastatin"]
        let dosages = ["500mg - 3x daily", "10mg - Once daily", "400mg - As needed", "500mg - Twice daily", "20mg - At bedtime"]
        
        for i in 0..<5 {
            let prescription = Prescription(context: viewContext)
            prescription.id = UUID()
            prescription.medicineName = medicines[i]
            prescription.dosage = dosages[i]
            prescription.prescription_appointment = appointments[i % appointments.count]
            prescription.prescription_user = users[i % users.count]
            prescription.prescription_doctor = doctors[i % doctors.count]
        }
        
        try? viewContext.save()
    }
}

