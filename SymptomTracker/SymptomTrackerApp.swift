//
//  SymptomTrackerApp.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

@main
struct SymptomTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appStateManager = AppStateManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appStateManager)
        }
    }
}