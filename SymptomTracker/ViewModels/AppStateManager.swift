//
//  AppStateManager.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

class AppStateManager: ObservableObject {
    // MARK: - CoreData
    private let persistentContainer: NSPersistentContainer
    private var userProfile: UserProfile?
    // MARK: - Onboarding State
    @Published var showOnboarding: Bool = true
    @Published var currentStep: Int = 0
    @Published var userName: String = ""
    @Published var selectedConditions: Set<String> = []
    @Published var selectedSymptoms: Set<String> = []
    @Published var severityLevel: Double = 5.0
    @Published var flareFrequency: String = "Weekly"
    @Published var selectedTriggers: Set<String> = []
    @Published var selectedRoutines: Set<String> = []
    @Published var selectedGoals: Set<String> = []
    
    // MARK: - Navigation State
    @Published var currentScreen: AppScreen = .home
    
    // MARK: - Data Arrays
    @Published var foodItems: [FoodItem] = []
    @Published var medications: [MedicationItem] = []
    @Published var symptoms: [SymptomItem] = []
    @Published var sleepLogs: [SleepLog] = []
    @Published var therapySessions: [TherapySession] = []
    @Published var timelineEntries: [TimelineEntryModel] = []
    @Published var selectedDate: Date = Date()
    
    // MARK: - Constants
    let availableConditions = [
        "Rheumatoid Arthritis", "Lupus", "Fibromyalgia", "Chronic Fatigue Syndrome",
        "Multiple Sclerosis", "Crohn's Disease", "IBS", "Endometriosis",
        "Psoriasis", "Eczema", "Migraine", "Anxiety", "Depression"
    ]
    
    let availableSymptoms = [
        "Joint Pain", "Fatigue", "Stiffness", "Swelling", "Brain Fog",
        "Sleep Issues", "Headaches", "Nausea", "Digestive Issues",
        "Mood Changes", "Skin Issues", "Muscle Pain", "Memory Problems"
    ]
    
    let availableTriggers = [
        "Stress", "Weather Changes", "Lack of Sleep", "Certain Foods",
        "Overexertion", "Hormonal Changes", "Infections", "Medication Changes"
    ]
    
    let availableRoutines = [
        "Morning Stretching", "Meditation", "Regular Exercise", "Healthy Eating",
        "Consistent Sleep Schedule", "Hydration", "Stress Management", "Gentle Movement"
    ]
    
    let availableGoals = [
        "Reduce Pain", "Improve Sleep", "Increase Energy", "Better Mood",
        "Manage Stress", "Maintain Mobility", "Track Patterns", "Build Habits"
    ]
    
    // MARK: - Initialization
    init() {
        print("🚀 AppStateManager: INITIALIZING...")
        print("🚀🚀🚀 THIS IS A TEST MESSAGE - IF YOU SEE THIS, LOGGING WORKS!")
        
        // Also write to a file to ensure we can see it
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let logFile = documentsPath.appendingPathComponent("debug_log.txt")
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let logMessage = "\(timestamp): AppStateManager INITIALIZING\n"
        
        if let data = logMessage.data(using: .utf8) {
            try? data.write(to: logFile, options: .atomic)
        }
        
        self.persistentContainer = PersistenceController.shared.container
        loadUserData()
        print("🚀 AppStateManager: INITIALIZATION COMPLETE")
        print("🚀🚀🚀 INITIALIZATION COMPLETE - LOGGING IS WORKING!")
        
        let completeMessage = "\(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)): AppStateManager INITIALIZATION COMPLETE\n"
        if let data = completeMessage.data(using: .utf8) {
            try? data.write(to: logFile, options: .atomic)
        }
    }
    
    // MARK: - CoreData Methods
    private func loadUserData() {
        print("📊 LOADING USER DATA...")
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let profiles = try context.fetch(request)
            print("📊 FOUND \(profiles.count) USER PROFILES")
            if let profile = profiles.first {
                print("✅ LOADING EXISTING USER DATA")
                print("   User: \(profile.userName ?? "Unknown")")
                print("   Onboarding Complete: \(profile.onboardingCompleted)")
                print("   Conditions: \(profile.conditions?.count ?? 0)")
                print("   Symptoms: \(profile.symptoms?.count ?? 0)")
                print("   Triggers: \(profile.triggers?.count ?? 0)")
                print("   Routines: \(profile.routines?.count ?? 0)")
                print("   Goals: \(profile.goals?.count ?? 0)")
                
                // Print actual data
                if let conditions = profile.conditions {
                    for condition in conditions {
                        if let userCondition = condition as? UserCondition {
                            print("   - Condition: \(userCondition.name ?? "Unknown")")
                        }
                    }
                }
                
                if let symptoms = profile.symptoms {
                    for symptom in symptoms {
                        if let userSymptom = symptom as? UserSymptom {
                            print("   - Symptom: \(userSymptom.name ?? "Unknown")")
                        }
                    }
                }
                
                self.userProfile = profile
                loadFromUserProfile(profile)
            } else {
                print("🆕 CREATING NEW USER PROFILE WITH DEFAULTS")
                // Create default profile with hardcoded values
                createDefaultUserProfile()
            }
        } catch {
            print("❌ Error loading user data: \(error)")
            createDefaultUserProfile()
        }
    }
    
    private func createDefaultUserProfile() {
        print("🆕 CREATING DEFAULT USER PROFILE...")
        let context = persistentContainer.viewContext
        let profile = UserProfile(context: context)
        
        // Set default values
        profile.userName = "User"
        profile.onboardingCompleted = false
        profile.severityLevel = 5.0
        profile.flareFrequency = "Weekly"
        
        // Add default conditions
        let defaultConditions = ["Rheumatoid Arthritis", "Lupus"]
        for conditionName in defaultConditions {
            let condition = UserCondition(context: context)
            condition.name = conditionName
            condition.userProfile = profile
        }
        
        // Add default symptoms
        let defaultSymptoms = ["Joint Pain", "Fatigue", "Brain Fog"]
        for symptomName in defaultSymptoms {
            let symptom = UserSymptom(context: context)
            symptom.name = symptomName
            symptom.userProfile = profile
        }
        
        // Add default triggers
        let defaultTriggers = ["Stress", "Weather Changes", "Lack of Sleep"]
        for triggerName in defaultTriggers {
            let trigger = UserTrigger(context: context)
            trigger.name = triggerName
            trigger.userProfile = profile
        }
        
        // Add default routines
        let defaultRoutines = ["Morning Stretching", "Regular Exercise", "Healthy Eating"]
        for routineName in defaultRoutines {
            let routine = UserRoutine(context: context)
            routine.name = routineName
            routine.userProfile = profile
        }
        
        // Add default goals
        let defaultGoals = ["Reduce Pain", "Improve Sleep", "Increase Energy"]
        for goalName in defaultGoals {
            let goal = UserGoal(context: context)
            goal.name = goalName
            goal.userProfile = profile
        }
        
        self.userProfile = profile
        saveContext()
        loadFromUserProfile(profile)
    }
    
    private func loadFromUserProfile(_ profile: UserProfile) {
        userName = profile.userName ?? ""
        showOnboarding = !profile.onboardingCompleted
        severityLevel = profile.severityLevel
        flareFrequency = profile.flareFrequency ?? "Weekly"
        
        // Load sets from relationships
        selectedConditions = Set(profile.conditions?.compactMap { ($0 as? UserCondition)?.name } ?? [])
        selectedSymptoms = Set(profile.symptoms?.compactMap { ($0 as? UserSymptom)?.name } ?? [])
        selectedTriggers = Set(profile.triggers?.compactMap { ($0 as? UserTrigger)?.name } ?? [])
        selectedRoutines = Set(profile.routines?.compactMap { ($0 as? UserRoutine)?.name } ?? [])
        selectedGoals = Set(profile.goals?.compactMap { ($0 as? UserGoal)?.name } ?? [])
        
        // Load arrays from relationships
        foodItems = (profile.foodItems?.allObjects as? [FoodItemEntity])?.compactMap { foodItem in
            FoodItem(
                name: foodItem.name ?? "",
                calories: Int(foodItem.calories),
                icon: foodItem.icon ?? "🍎",
                color: Color.fromData(foodItem.colorData ?? Data()) ?? .defaultRed,
                mealType: foodItem.mealType ?? "Breakfast"
            )
        } ?? []
        
        medications = (profile.medications?.allObjects as? [MedicationItemEntity])?.compactMap { medItem in
            MedicationItem(
                name: medItem.name ?? "",
                dosage: medItem.dosage ?? "",
                frequency: medItem.frequency ?? "",
                icon: medItem.icon ?? "💊",
                color: Color.fromData(medItem.colorData ?? Data()) ?? .defaultBlue,
                isTaken: medItem.isTaken
            )
        } ?? []
        
        symptoms = (profile.symptomLogs?.allObjects as? [SymptomLogEntity])?.compactMap { symptomLog in
            SymptomItem(
                name: symptomLog.name ?? "",
                severity: Int(symptomLog.severity),
                notes: symptomLog.notes ?? "",
                timestamp: symptomLog.timestamp ?? Date()
            )
        } ?? []
        
        sleepLogs = (profile.sleepLogs?.allObjects as? [SleepLogEntity])?.compactMap { sleepLog in
            SleepLog(
                sleepHours: sleepLog.sleepHours,
                quality: Int(sleepLog.quality),
                notes: sleepLog.notes ?? "",
                date: sleepLog.date ?? Date()
            )
        } ?? []
        
        therapySessions = (profile.therapySessions?.allObjects as? [TherapySessionEntity])?.compactMap { therapySession in
            TherapySession(
                type: therapySession.type ?? "",
                duration: Int(therapySession.duration),
                notes: therapySession.notes ?? "",
                date: therapySession.date ?? Date()
            )
        } ?? []

        timelineEntries = (profile.timelineEntries?.allObjects as? [TimelineEntry])?.compactMap { entry in
            TimelineEntryModel(
                type: TimelineEntryType(rawValue: entry.type ?? "symptom") ?? .symptom,
                title: entry.title ?? "",
                subtitle: entry.subtitle ?? "",
                icon: entry.icon ?? "❓",
                timestamp: entry.timestamp ?? Date(),
                data: entry.data
            )
        } ?? []
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            print("💾 SAVING CONTEXT - Changes detected")
            do {
                try context.save()
                print("✅ CONTEXT SAVED SUCCESSFULLY!")
            } catch {
                print("❌ Error saving context: \(error)")
            }
        } else {
            print("💾 No changes to save")
        }
    }
    
    private func saveUserProfile() {
        guard let profile = userProfile else { 
            print("❌ No userProfile to save!")
            return 
        }
        
        print("💾 SAVING USER PROFILE...")
        print("   UserName: \(userName)")
        print("   OnboardingCompleted: \(!showOnboarding)")
        print("   SeverityLevel: \(severityLevel)")
        print("   FlareFrequency: \(flareFrequency)")
        
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
        
        // Add new conditions
        print("   Adding \(selectedConditions.count) conditions:")
        for conditionName in selectedConditions {
            let condition = UserCondition(context: persistentContainer.viewContext)
            condition.name = conditionName
            condition.userProfile = profile
            print("     - \(conditionName)")
        }
        
        // Add new symptoms
        print("   Adding \(selectedSymptoms.count) symptoms:")
        for symptomName in selectedSymptoms {
            let symptom = UserSymptom(context: persistentContainer.viewContext)
            symptom.name = symptomName
            symptom.userProfile = profile
            print("     - \(symptomName)")
        }
        
        // Add new triggers
        print("   Adding \(selectedTriggers.count) triggers:")
        for triggerName in selectedTriggers {
            let trigger = UserTrigger(context: persistentContainer.viewContext)
            trigger.name = triggerName
            trigger.userProfile = profile
            print("     - \(triggerName)")
        }
        
        // Add new routines
        print("   Adding \(selectedRoutines.count) routines:")
        for routineName in selectedRoutines {
            let routine = UserRoutine(context: persistentContainer.viewContext)
            routine.name = routineName
            routine.userProfile = profile
            print("     - \(routineName)")
        }
        
        // Add new goals
        print("   Adding \(selectedGoals.count) goals:")
        for goalName in selectedGoals {
            let goal = UserGoal(context: persistentContainer.viewContext)
            goal.name = goalName
            goal.userProfile = profile
            print("     - \(goalName)")
        }
        
        saveContext()
    }
    
    // MARK: - Methods
    func completeOnboarding() {
        print("🎉 COMPLETING ONBOARDING")
        showOnboarding = false
        currentScreen = .home
        saveUserProfile()
    }
    
    func resetOnboarding() {
        showOnboarding = true
        currentStep = 0
        userName = ""
        selectedConditions.removeAll()
        selectedSymptoms.removeAll()
        severityLevel = 5.0
        flareFrequency = "Weekly"
        selectedTriggers.removeAll()
        selectedRoutines.removeAll()
        selectedGoals.removeAll()
        saveUserProfile()
    }
    
    func saveOnboardingData() {
        print("💾 SAVING ONBOARDING DATA")
        print("   Conditions: \(selectedConditions)")
        print("   Symptoms: \(selectedSymptoms)")
        print("   Triggers: \(selectedTriggers)")
        print("   Routines: \(selectedRoutines)")
        print("   Goals: \(selectedGoals)")
        print("   UserProfile exists: \(userProfile != nil)")
        saveUserProfile()
    }
    
    func navigateTo(_ screen: AppScreen) {
        currentScreen = screen
    }
    
    func addFoodItem(_ item: FoodItem) {
        foodItems.append(item)
        saveFoodItemToCoreData(item)
    }
    
    func addMedication(_ medication: MedicationItem) {
        medications.append(medication)
        saveMedicationToCoreData(medication)
    }
    
    func toggleMedication(_ medication: MedicationItem) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
            updateMedicationInCoreData(medications[index])
        }
    }
    
    func addSymptom(_ symptom: SymptomItem) {
        symptoms.append(symptom)
        saveSymptomToCoreData(symptom)
    }
    
    func addSleepLog(_ log: SleepLog) {
        sleepLogs.append(log)
        saveSleepLogToCoreData(log)
    }
    
    func addTherapySession(_ session: TherapySession) {
        therapySessions.append(session)
        saveTherapySessionToCoreData(session)
    }
    
    // MARK: - CoreData Save Methods
    private func saveFoodItemToCoreData(_ item: FoodItem) {
        guard let profile = userProfile else { return }
        let context = persistentContainer.viewContext

        let foodItem = FoodItemEntity(context: context)
        foodItem.name = item.name
        foodItem.calories = Int32(item.calories)
        foodItem.icon = item.icon
        foodItem.colorData = item.color.toData()
        foodItem.dateAdded = Date()
        foodItem.mealType = item.mealType
        foodItem.userProfile = profile

        addTimelineEntry(
            type: .food,
            title: "\(item.mealType): \(item.name)",
            subtitle: "\(item.calories) calories",
            icon: item.icon
        )

        saveContext()
    }
    
    private func saveMedicationToCoreData(_ medication: MedicationItem) {
        guard let profile = userProfile else { return }
        let context = persistentContainer.viewContext

        let medItem = MedicationItemEntity(context: context)
        medItem.name = medication.name
        medItem.dosage = medication.dosage
        medItem.frequency = medication.frequency
        medItem.icon = medication.icon
        medItem.colorData = medication.color.toData()
        medItem.isTaken = medication.isTaken
        medItem.dateAdded = Date()
        medItem.userProfile = profile

        if medication.isTaken {
            addTimelineEntry(
                type: .medication,
                title: medication.name,
                subtitle: "\(medication.dosage) - \(medication.frequency)",
                icon: medication.icon
            )
        }

        saveContext()
    }
    
    private func updateMedicationInCoreData(_ medication: MedicationItem) {
        // This would need to be implemented based on how you want to match medications
        // For now, we'll just save the context
        saveContext()
    }
    
    private func saveSymptomToCoreData(_ symptom: SymptomItem) {
        guard let profile = userProfile else { return }
        let context = persistentContainer.viewContext

        let symptomLog = SymptomLogEntity(context: context)
        symptomLog.name = symptom.name
        symptomLog.severity = Int32(symptom.severity)
        symptomLog.notes = symptom.notes
        symptomLog.timestamp = symptom.timestamp
        symptomLog.userProfile = profile

        addTimelineEntry(
            type: .symptom,
            title: symptom.name,
            subtitle: "Severity: \(symptom.severity)/10",
            icon: "❤️‍🩹"
        )

        saveContext()
    }
    
    private func saveSleepLogToCoreData(_ log: SleepLog) {
        guard let profile = userProfile else { return }
        let context = persistentContainer.viewContext

        let sleepLog = SleepLogEntity(context: context)
        sleepLog.sleepHours = log.sleepHours
        sleepLog.quality = Int32(log.quality)
        sleepLog.notes = log.notes
        sleepLog.date = log.date
        sleepLog.userProfile = profile

        addTimelineEntry(
            type: .rest,
            title: "Sleep Log",
            subtitle: "\(log.sleepHours) hours, Quality: \(log.quality)/10",
            icon: "😴"
        )

        saveContext()
    }

    private func saveTherapySessionToCoreData(_ session: TherapySession) {
        guard let profile = userProfile else { return }
        let context = persistentContainer.viewContext

        let therapySession = TherapySessionEntity(context: context)
        therapySession.type = session.type
        therapySession.duration = Int32(session.duration)
        therapySession.notes = session.notes
        therapySession.date = session.date
        therapySession.userProfile = profile

        addTimelineEntry(
            type: .therapy,
            title: session.type,
            subtitle: "\(session.duration) minutes",
            icon: "🧠"
        )

        saveContext()
    }

    func addTimelineEntry(type: TimelineEntryType, title: String, subtitle: String, icon: String, timestamp: Date = Date()) {
        guard let profile = userProfile else { return }
        let context = persistentContainer.viewContext

        let entry = TimelineEntry(context: context)
        entry.id = UUID()
        entry.type = type.rawValue
        entry.title = title
        entry.subtitle = subtitle
        entry.icon = icon
        entry.timestamp = timestamp
        entry.userProfile = profile

        let timelineModel = TimelineEntryModel(
            type: type,
            title: title,
            subtitle: subtitle,
            icon: icon,
            timestamp: timestamp
        )

        timelineEntries.append(timelineModel)
        timelineEntries.sort { $0.timestamp > $1.timestamp }
    }

    func getTimelineEntriesForDate(_ date: Date) -> [TimelineEntryModel] {
        let calendar = Calendar.current
        return timelineEntries.filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
    }
    
    func deleteMedication(_ medication: MedicationItem) {
        medications.removeAll { $0.id == medication.id }
        saveOnboardingData()
    }
}