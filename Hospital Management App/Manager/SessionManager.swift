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
            } else {
                UserDefaults.standard.removeObject(forKey: "LoggedInUserID")
            }
        }
    }
    
    var isLoggedIn: Bool {
        return currentUserID != nil && !(currentUserID?.isEmpty ?? true)
    }
    
    private init() {
        if let savedID = UserDefaults.standard.string(forKey: "LoggedInUserID"), !savedID.isEmpty {
            self.currentUserID = savedID
        } else {
        }
    }
    
    func getActiveUser(in context: NSManagedObjectContext) -> User? {
        guard let idString = currentUserID, let uuid = UUID(uuidString: idString) else {
            return nil
        }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1
        
        do {
            let user = try context.fetch(request).first
            if let user = user {
            } else {
            }
            return user
        } catch {
            return nil
        }
    }
    
    func logout() {
        self.currentUserID = nil
    }
}
