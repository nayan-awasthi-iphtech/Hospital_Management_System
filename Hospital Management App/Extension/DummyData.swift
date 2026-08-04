//
//  DummyData.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

internal import CoreData
import SwiftUI

extension Doctor {
    static func DoctorDummyData(viewContext: NSManagedObjectContext) {
        let names = ["Dr. Alice Green", "Dr. Brian Patel", "Dr. Clara Oswald", "Dr. David Kim", "Dr. Elena Rostova"]
        let departments = ["Cardiology", "Pediatrics", "Neurology", "Orthopedics", "Dermatology"]
        let experiences: [Int16] = [12, 8, 15, 6, 10]
        let qualifications = ["MD, FACC", "MD (Pediatrics)", "DM (Neurology), MBBS", "MS (Orthopedics)", "MD, DNB (Dermatology)"]
        
        let abouts = [
            "Dr. Alice Green is a highly dedicated cardiologist specializing in non-invasive cardiovascular care and preventive heart health. She is committed to providing compassionate, evidence-based care tailored to each patient.",
            "Dr. Brian Patel is a caring pediatrician focused on child development, wellness checkups, and early disease prevention. He strives to create a comfortable and welcoming environment for children and their families.",
            "Dr. Clara Oswald is an experienced neurologist with specialized training in complex brain and nervous system disorders. She focuses on personalized diagnostic strategies and long-term condition management.",
            "Dr. David Kim is a skilled orthopedic surgeon expertise in sports injuries, joint preservation, and advanced surgical recovery techniques, helping patients return to an active lifestyle.",
            "Dr. Elena Rostova is a board-certified dermatologist specializing in clinical, surgical, and cosmetic skin care solutions, dedicated to promoting overall skin health and patient confidence."
        ]
        
        for i in 0..<5 {
            let doctor = Doctor(context: viewContext)
            doctor.id = UUID()
            doctor.name = names[i]
            doctor.department = departments[i]
            doctor.experienceYears = experiences[i]
            doctor.qualification = qualifications[i]
            doctor.about = abouts[i]
            
            if let uiImage = UIImage(named: "doctor\(i+1)") {
                doctor.imageData = uiImage.jpegData(compressionQuality: 0.8)
            }
        }
        
        do {
            try viewContext.save()
            print("Doctor dummy data created successfully!")
        } catch {
            print("Error saving Doctor dummy data: \(error.localizedDescription)")
        }
    }
}

extension Medicine {
    
    static let dummyMedicineTemplate: [(name: String, dosage: String, category: String, frequency: String, nextTime: String, daysLeft: Int16)] = [
        ("Amlodipine", "5mg", "Blood Pressure", "Once daily", "8:00 AM", 15),
        ("Metformin", "500mg", "Diabetes", "Twice daily", "2:00 PM", 5),
        ("Atorvastatin", "10mg", "Cholesterol", "Once daily", "9:00 PM", 20),
        ("Vitamin D3", "1000 IU", "Supplement", "Once daily", "8:00 AM", 30)
    ]
    
    static func MedicineDummyData(viewContext: NSManagedObjectContext, for user: User? = nil) {
        for item in dummyMedicineTemplate {
            let medicine = Medicine(context: viewContext)
            medicine.id = UUID()
            medicine.name = item.name
            medicine.dosage = item.dosage
            medicine.category = item.category
            medicine.frequency = item.frequency
            medicine.nextTime = item.nextTime
            medicine.isTaken = false
            medicine.daysLeft = item.daysLeft
            medicine.medicine_user = user
        }
        do {
            try viewContext.save()
            print("Medicine dummy data created successfully!")
        } catch {
            print("Error saving medicine dummy data: \(error.localizedDescription)")
        }
    }
    
    static func createMedicinesForUser(_ user: User, in viewContext: NSManagedObjectContext) {
        guard (user.user_medicine?.count ?? 0) == 0 else {
            print("User already has \(user.user_medicine?.count ?? 0) medicines. Skipping creation.")
            return
        }
        
        for item in dummyMedicineTemplate {
            let medicine = Medicine(context: viewContext)
            medicine.id = UUID()
            medicine.name = item.name
            medicine.dosage = item.dosage
            medicine.category = item.category
            medicine.frequency = item.frequency
            medicine.nextTime = item.nextTime
            medicine.isTaken = false
            medicine.daysLeft = item.daysLeft
            medicine.medicine_user = user
            user.addToUser_medicine(medicine)
        }
        
        do {
            try viewContext.save()
            print("Created \(dummyMedicineTemplate.count) medicines for user \(user.name ?? "?")")
        } catch {
            print("Error saving per-user medicines: \(error.localizedDescription)")
        }
    }
}

extension Appointment {
    static let availableTimeSlots = ["09:00 AM", "11:30 AM", "02:00 PM", "03:30 PM", "05:00 PM"]
}
