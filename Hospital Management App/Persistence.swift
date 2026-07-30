//
//  Persistence.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let context = result.container.viewContext
        
        Doctor.DoctorDummyData(viewContext: context)
        Medicine.MedicineDummyData(viewContext: context)
       
        return result
    }()
    
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
        
        if !inMemory {
            checkAndSeedDatabase()
        }
    }
    
    private func checkAndSeedDatabase() {
        let context = container.viewContext
        let doctorRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let count = try context.count(for: doctorRequest)
            if count == 0 {
                print("Database empty. Seeding permanent entities sequentially...")
                
                Doctor.DoctorDummyData(viewContext: context)
                Medicine.MedicineDummyData(viewContext: context)
                print("Permanent database seeding successful and saved to disk!")
            }
        } catch {
            print("Failed to look up or write persistent seed entries: \(error)")
        }
    }
}

