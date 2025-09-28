//
//  Persistence.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create a sample user profile for preview
        let userProfile = UserProfile(context: viewContext)
        userProfile.userName = "Preview User"
        userProfile.onboardingCompleted = true
        userProfile.severityLevel = 5.0
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SymptomTracker")
        if inMemory {
            guard let firstStore = container.persistentStoreDescriptions.first else {
                fatalError("No persistent store descriptions found")
            }
            firstStore.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("❌ CoreData Error: \(error), \(error.userInfo)")
                // Don't fatalError in production, just log the error
                // fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ CoreData loaded successfully")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
