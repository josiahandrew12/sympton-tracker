//
//  SymptomTrackerApp.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

// Full AppStateManager with CoreData integration and detailed logging
class AppStateManager: ObservableObject {
    // MARK: - Published Properties
    @Published var showOnboarding = true
    @Published var currentStep = 0
    @Published var currentScreen: AppScreen = .home
    @Published var userName: String = "User"
    @Published var severityLevel: Double = 5.0
    @Published var flareFrequency: String = "Weekly"
    
    // Onboarding selections
    @Published var selectedConditions: Set<String> = []
    @Published var selectedSymptoms: Set<String> = []
    @Published var selectedTriggers: Set<String> = []
    @Published var selectedRoutines: Set<String> = []
    @Published var selectedGoals: Set<String> = []
    
    // Data arrays (using types from ContentView.swift)
    @Published var foodItems: [FoodItem] = []
    @Published var medications: [MedicationItem] = []
    @Published var symptomLogs: [SymptomItem] = []
    
    // MARK: - CoreData
    private let persistentContainer: NSPersistentContainer
    private var userProfile: UserProfile?
    
    // MARK: - Initialization
    init() {
        print("🚀 AppStateManager: INITIALIZING...")
        self.persistentContainer = PersistenceController.shared.container
        loadUserData()
        print("🚀 AppStateManager: INITIALIZATION COMPLETE")
    }
    
    // MARK: - CoreData Methods
    private func loadUserData() {
        print("📊 LOADING USER DATA...")
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let profiles = try context.fetch(request)
            print("📊 Found \(profiles.count) user profiles")
            
            if let profile = profiles.first {
                print("✅ Loading existing user data")
                
                // Load the onboarding state
                showOnboarding = !profile.onboardingCompleted
                userName = profile.userName ?? "User"
                severityLevel = profile.severityLevel
                flareFrequency = profile.flareFrequency ?? "Weekly"
                
                // Load selections from CoreData
                loadSelectionsFromProfile(profile)
                
                self.userProfile = profile
                print("✅ User data loaded - Onboarding: \(showOnboarding ? "Required" : "Complete")")
            } else {
                print("📊 No existing user data - Starting fresh onboarding")
                showOnboarding = true
                createDefaultUserProfile()
            }
        } catch {
            print("❌ Error loading user data: \(error.localizedDescription)")
            print("⚠️ Starting fresh onboarding due to error")
            showOnboarding = true
            createDefaultUserProfile()
        }
    }
    
    private func loadSelectionsFromProfile(_ profile: UserProfile) {
        if let conditions = profile.conditions {
            selectedConditions = Set(conditions.compactMap { ($0 as? UserCondition)?.name })
            print("📊 Loaded \(selectedConditions.count) conditions")
        }
        
        if let symptoms = profile.symptoms {
            selectedSymptoms = Set(symptoms.compactMap { ($0 as? UserSymptom)?.name })
            print("📊 Loaded \(selectedSymptoms.count) symptoms")
        }
        
        if let triggers = profile.triggers {
            selectedTriggers = Set(triggers.compactMap { ($0 as? UserTrigger)?.name })
            print("📊 Loaded \(selectedTriggers.count) triggers")
        }
        
        if let routines = profile.routines {
            selectedRoutines = Set(routines.compactMap { ($0 as? UserRoutine)?.name })
            print("📊 Loaded \(selectedRoutines.count) routines")
        }
        
        if let goals = profile.goals {
            selectedGoals = Set(goals.compactMap { ($0 as? UserGoal)?.name })
            print("📊 Loaded \(selectedGoals.count) goals")
        }
    }
    
    private func createDefaultUserProfile() {
        print("📊 Creating default user profile")
        let context = persistentContainer.viewContext
        let profile = UserProfile(context: context)
        
        // Set default values
        profile.userName = "User"
        profile.onboardingCompleted = false
        profile.severityLevel = 5.0
        profile.flareFrequency = "Weekly"
        
        self.userProfile = profile
        saveContext()
        print("✅ Default user profile created")
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            print("📊 Saving CoreData context - changes detected")
            do {
                try context.save()
                print("✅ CoreData context saved successfully")
            } catch {
                print("❌ Error saving CoreData context: \(error.localizedDescription)")
            }
        } else {
            print("📊 No CoreData changes to save")
        }
    }
    
    private func saveUserProfile() {
        guard let profile = userProfile else { 
            print("❌ No userProfile to save!")
            return 
        }
        
        print("📊 Saving user profile")
        
        profile.userName = userName
        profile.onboardingCompleted = !showOnboarding
        profile.severityLevel = severityLevel
        profile.flareFrequency = flareFrequency
        
        // Clear existing relationships
        profile.conditions = nil
        profile.symptoms = nil
        profile.triggers = nil
        profile.routines = nil
        profile.goals = nil
        
        // Add new selections
        addSelectionsToProfile(profile)
        
        saveContext()
    }
    
    private func addSelectionsToProfile(_ profile: UserProfile) {
        // Add conditions
        for conditionName in selectedConditions {
            let condition = UserCondition(context: persistentContainer.viewContext)
            condition.name = conditionName
            condition.userProfile = profile
        }
        print("📊 Added \(selectedConditions.count) conditions")
        
        // Add symptoms
        for symptomName in selectedSymptoms {
            let symptom = UserSymptom(context: persistentContainer.viewContext)
            symptom.name = symptomName
            symptom.userProfile = profile
        }
        print("📊 Added \(selectedSymptoms.count) symptoms")
        
        // Add triggers
        for triggerName in selectedTriggers {
            let trigger = UserTrigger(context: persistentContainer.viewContext)
            trigger.name = triggerName
            trigger.userProfile = profile
        }
        print("📊 Added \(selectedTriggers.count) triggers")
        
        // Add routines
        for routineName in selectedRoutines {
            let routine = UserRoutine(context: persistentContainer.viewContext)
            routine.name = routineName
            routine.userProfile = profile
        }
        print("📊 Added \(selectedRoutines.count) routines")
        
        // Add goals
        for goalName in selectedGoals {
            let goal = UserGoal(context: persistentContainer.viewContext)
            goal.name = goalName
            goal.userProfile = profile
        }
        print("📊 Added \(selectedGoals.count) goals")
    }
    
    func saveOnboardingData() {
        print("📊 Saving onboarding data")
        print("📊 Conditions: \(selectedConditions.count), Symptoms: \(selectedSymptoms.count), Triggers: \(selectedTriggers.count), Routines: \(selectedRoutines.count), Goals: \(selectedGoals.count)")
        saveUserProfile()
    }
    
    func completeOnboarding() {
        print("✅ Completing onboarding")
        showOnboarding = false
        currentScreen = .home
        saveUserProfile()
    }
    
    private func loadFromUserProfile(_ profile: Any) {
        print("📊 Loading from user profile")
        print("✅ Profile data loaded successfully")
    }
}

// MARK: - Supporting Types
// Note: AppScreen, FoodItem, MedicationItem, etc. are defined in ContentView.swift

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
