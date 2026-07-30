//
//  SessionManager.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 30/07/26.
//

import SwiftUI
internal import CoreData
internal import Combine

class SessionManager: ObservableObject {
    
    static let shared = SessionManager()
    
    @Published var currentUserID: String? {
        didSet {
            if let id = currentUserID {
                UserDefaults.standard.set(id, forKey: "LoggedInUserID")
                print("💾 [SessionManager] Saved user session to UserDefaults: \(id)")
            } else {
                UserDefaults.standard.removeObject(forKey: "LoggedInUserID")
                print("🗑️ [SessionManager] Cleared user session from UserDefaults")
            }
        }
    }
    
    var isLoggedIn: Bool {
        return currentUserID != nil && !(currentUserID?.isEmpty ?? true)
    }
    
    private init() {
        // Restore active user session from UserDefaults on app launch!
        if let savedID = UserDefaults.standard.string(forKey: "LoggedInUserID"), !savedID.isEmpty {
            self.currentUserID = savedID
            print("🚀 [SessionManager] Restored active session on startup: \(savedID)")
        } else {
            print("🚀 [SessionManager] No active session found on startup.")
        }
    }
    
    func getActiveUser(in context: NSManagedObjectContext) -> User? {
        guard let idString = currentUserID, let uuid = UUID(uuidString: idString) else {
            print("❌ [SessionManager] Invalid UUID string in session: \(currentUserID ?? "nil")")
            return nil
        }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1
        
        do {
            let user = try context.fetch(request).first
            if let user = user {
                print("👤 [SessionManager] Active user fetched successfully: \(user.name ?? "Unknown")")
            } else {
                print("⚠️ [SessionManager] No Core Data record matching ID: \(idString)")
            }
            return user
        } catch {
            print("❌ [SessionManager] Error fetching active user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func logout() {
        print("🚪 [SessionManager] User logging out...")
        self.currentUserID = nil
    }
}
