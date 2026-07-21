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
        let allergies = ["Penicillin", "None", "Peanuts", "Sulfa Drugs", "None"]
        
        let addresses = [
            "123 Innovation Way, New York, NY",
            "456 Oak Avenue, Los Angeles, CA",
            "789 Pine Road, San Francisco, CA",
            "321 Maple Drive, Austin, TX",
            "654 Cedar Lane, Chicago, IL"
        ]
        let emails = ["john.doe@email.com", "jane.smith@email.com", "r.chen@email.com", "emily.r@email.com", "w.taylor@email.com"]
        let genders = ["Male", "Female", "Male", "Female", "Male"]
        let heights = ["180 cm", "165 cm", "175 cm", "160 cm", "182 cm"]
        let weights = ["65", "85", "75", "45", "65"]
        let phones = ["+1 (555) 019-2831", "+1 (555) 014-9928", "+1 (555) 012-4819", "+1 (555) 016-3391", "+1 (555) 019-7722"]
        
        let insuranceDetailsPool = [
            "BlueShield Platinum PPO",
            "UnitedHealth Care Choice Plus",
            "Aetna Premium Health HMO",
            "Cigna Open Access Plus",
            "Humana Gold Value Plan"
        ]
        
        let PolicyIdDetails = ["#BS-994821-X", "#UH-883719-A", "#AE-441029-M", "#CG-772911-B", "#HU-110293-K"]
        
        let emergencyContactsPool: [Int32] = [
            5550143,
            5550188,
            5550121,
            5550165,
            5550190
        ]
        
        let calendar = Calendar.current
        let birthYears = [1985, 1992, 1978, 2000, 1989]
        
        for i in 0..<5 {
            let user = User(context: viewContext)
            user.id = UUID()
            user.name = names[i]
            user.bloodGroup = bloodGroups[i]
            user.allergies = allergies[i]
            user.emergencyContact = emergencyContactsPool[i]
            user.insuranceDetails = insuranceDetailsPool[i]
            user.policyId = PolicyIdDetails[i]
            
            user.address = addresses[i]
            user.email = emails[i]
            user.gender = genders[i]
            user.height = heights[i]
            user.weight = weights[i]
            user.phone = phones[i]
            
            var dateComponents = DateComponents()
            dateComponents.year = birthYears[i]
            dateComponents.month = (i * 2) + 1
            dateComponents.day = (i * 5) + 1
            user.dob = calendar.date(from: dateComponents) ?? Date()
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
    
    static let availableTimeSlots = ["09:00 AM", "11:30 AM", "02:00 PM", "03:30 PM", "05:00 PM"]
    
    static func AppointmentDummyData(viewContext:NSManagedObjectContext){
        
        let users: [User] = (try? viewContext.fetch(User.fetchRequest())) ?? []
        let doctors: [Doctor] = (try? viewContext.fetch(Doctor.fetchRequest())) ?? []
        
        guard !users.isEmpty && !doctors.isEmpty else { return }
        
        
        let statuses = ["Scheduled", "Completed", "Scheduled", "Canceled", "Scheduled"]
        
        let calendar = Calendar.current
        
        for i in 0..<5 {
            let appointment = Appointment(context: viewContext)
            appointment.status = statuses[i]
            appointment.timeSlot = Appointment.availableTimeSlots[i % Appointment.availableTimeSlots.count]
            appointment.id = UUID()
            appointment.appointment_user = users[i % users.count]
            appointment.appointment_doctor = doctors[i % doctors.count]
            appointment.date = calendar.date(byAdding: .day, value: i, to: Date()) ?? Date()
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
        let dosages = ["500mg", "10mg", "400mg", "500mg", "20mg"]
        let frequencies = ["3x daily", "Once daily", "As needed", "Twice daily", "At bedtime"]
        let states = [true, false, true, false, true]
        
        let calendar = Calendar.current
        
        for i in 0..<5 {
            let prescription = Prescription(context: viewContext)
            prescription.id = UUID()
            prescription.medicineName = medicines[i]
            prescription.dosage = dosages[i]
            
            prescription.frequency = frequencies[i]
            prescription.isTaken = states[i]
            prescription.startDate = calendar.date(byAdding: .day,value: -i, to: Date()) ?? Date()
            prescription.prescription_appointment = appointments[i % appointments.count]
            prescription.prescription_user = users[i % users.count]
            prescription.prescription_doctor = doctors[i % doctors.count]
        }
        
        try? viewContext.save()
    }
}

