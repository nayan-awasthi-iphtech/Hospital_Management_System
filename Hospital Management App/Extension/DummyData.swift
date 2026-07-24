//
//  DummyData.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

internal import CoreData
import SwiftUI

extension User {
    @discardableResult
    static func UserDummyData(viewContext: NSManagedObjectContext) -> User? {
        let user = User(context: viewContext)
        user.id = UUID()
        user.name = "Emily Rodriguez"
        user.bloodGroup = "AB+"
        user.allergies = "Sulfa Drugs"
        user.emergencyContact = 5550165
        user.insuranceDetails = "Cigna Open Access Plus"
        user.policyId = "#CG-772911-B"
        user.address = "321 Maple Drive, Austin, TX"
        user.email = "emily.r@email.com"
        user.gender = "Female"
        user.height = "160"
        user.weight = "55"
        user.phone = "+1 (555) 016-3391"
        
        var dateComponents = DateComponents()
        dateComponents.year = 2000
        dateComponents.month = 1
        dateComponents.day = 1
        user.dob = Calendar.current.date(from: dateComponents) ?? Date()
        
        do {
            try viewContext.save()
            print("Single user created successfully!")
            return user
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
        return nil
    }
}

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
            doctor.about = abouts[i] // Make sure this matches your Core Data attribute name (e.g., doctor.about or doctor.aboutDoctor)
            
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
        
        do {
            try viewContext.save()
            print("Appointment dummy data created successfully!")
        } catch {
            print("Error saving Appoinment dummy data: \(error.localizedDescription)")
        }
        
    }
}

extension Prescription {
    
    static func PrescriptionDummyData(viewContext:NSManagedObjectContext){
        
        let appointments = (try? viewContext.fetch(Appointment.fetchRequest())) ?? []
        let users = (try? viewContext.fetch(User.fetchRequest())) ?? []
        let doctors = (try? viewContext.fetch(Doctor.fetchRequest())) ?? []
        
        guard !appointments.isEmpty else { return }
        
        let doctorNotes = [
            "Take with a full glass of water in the morning.",
            "Take after meals. Avoid consuming alcohol.",
            "Take before bedtime. Do not skip doses.",
            "Take once daily with breakfast.",
            "Take twice daily after food as needed."
        ]
        
        let calendar = Calendar.current
        
        for i in 0..<5 {
            let prescription = Prescription(context: viewContext)
            prescription.id = UUID()
            prescription.notes = doctorNotes[i]
            prescription.startDate = calendar.date(byAdding: .day,value: -i, to: Date()) ?? Date()
            prescription.prescription_appointment = appointments[i % appointments.count]
            prescription.prescription_user = users[i % users.count]
            prescription.prescription_doctor = doctors[i % doctors.count]
        }
        
        do {
            try viewContext.save()
            print("Prescription dummy data created successfully!")
        } catch {
            print("Error saving Prescription dummy data: \(error.localizedDescription)")
        }
        
    }
}

extension Medicine {
    static func MedicineDummyData(viewContext: NSManagedObjectContext) {
        
        let users = (try? viewContext.fetch(User.fetchRequest())) ?? []
        let prescriptions = (try? viewContext.fetch(Prescription.fetchRequest())) ?? []
        
        guard let user = users.first else {
            print("Please create User dummy data first!")
            return
        }
        
        let names = ["Amlodipine", "Metformin", "Atorvastatin", "Vitamin D3"]
        let dosages = ["5mg", "500mg", "10mg", "1000 IU"]
        let categories = ["Blood Pressure", "Diabetes", "Cholesterol", "Supplement"]
        let frequencies = ["Once daily", "Twice daily", "Once daily", "Once daily"]
        let nextTimes = ["8:00 AM", "2:00 PM", "9:00 PM", "8:00 AM"]
        let states = [true, false, false, true]
        let daysLeftList: [Int16] = [15, 5, 20, 30]
        
        for i in 0..<names.count {
            let medicine = Medicine(context: viewContext)
            medicine.id = UUID()
            medicine.name = names[i]
            medicine.dosage = dosages[i]
            medicine.category = categories[i]
            medicine.frequency = frequencies[i]
            medicine.nextTime = nextTimes[i]
            medicine.isTaken = states[i]
            medicine.daysLeft = daysLeftList[i]
            medicine.medicine_user = user
            
            if !prescriptions.isEmpty {
                medicine.medicine_prescription = prescriptions[i % prescriptions.count]
            }
        }
        
        do {
            try viewContext.save()
            print("Medicine dummy data created successfully!")
        } catch {
            print("Error saving medicine dummy data: \(error.localizedDescription)")
        }
    }
}

extension HealthLog {
    static func HealthLogDummyData(viewContext: NSManagedObjectContext, user: User) {
        
        let calendar = Calendar.current
        
        let bpms: [Double] = [76.0, 74.0, 71.0, 69.0, 72.0]
        let spo2Values: [Double] = [97.0, 98.0, 99.0, 98.0, 98.5]
        
        for i in 0..<5 {
            let log = HealthLog(context: viewContext)
            log.id = UUID()
            log.bpm = bpms[i]
            log.spo2 = spo2Values[i]
            log.date = calendar.date(byAdding: .month, value: -(4 - i), to: Date()) ?? Date()
            log.healthLog_user = user
        }
        
        do {
            try viewContext.save()
            print("HealthLog dummy data created successfully!")
        } catch {
            print("Error saving HealthLog dummy data: \(error.localizedDescription)")
        }
    }
}
