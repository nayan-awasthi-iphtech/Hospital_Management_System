//
//  Persistence.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        User.UserDummyData(viewContext: viewContext)
        Doctor.DoctorDummyData(viewContext: viewContext)
        Appointment.ApppointmentDummyData(viewContext: viewContext)
        Prescription.PrescriptionDummyData(viewContext: viewContext)
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Hospital_Management_App")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Run seed check for production device storage on startup
        if !inMemory {
            checkAndSeedDatabase()
        }
    }
    
    // Check if empty, then invoke the individual seed methods
    private func checkAndSeedDatabase() {
        let context = container.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                print("Database empty. Seeding permanent entities sequentially...")
                User.UserDummyData(viewContext: context)
                Doctor.DoctorDummyData(viewContext: context)
                Appointment.ApppointmentDummyData(viewContext: context)
                Prescription.PrescriptionDummyData(viewContext: context)
                print("Permanent database seeding successful!")
            }
        } catch {
            print("Failed to look up or write persistent seed entries: \(error)")
        }
    }
}
