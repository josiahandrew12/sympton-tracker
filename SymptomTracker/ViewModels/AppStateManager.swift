//
//  AppStateManager.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

/// Main app state manager that handles all user data and navigation
/// All UI updates are performed on the main thread via @MainActor annotations on methods
/// This class manages:
/// - User profile and onboarding state
/// - Navigation between screens
/// - CoreData persistence for all tracked items (symptoms, medications, food, sleep, therapy)
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
        AppLogger.info("AppStateManager: Initializing...")
        
        self.persistentContainer = PersistenceController.shared.container
        loadUserData()
        
        AppLogger.success("AppStateManager: Initialization complete")
    }
    
    // MARK: - CoreData Methods
    private func loadUserData() {
        AppLogger.debug("Loading user data...")
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let profiles = try context.fetch(request)
            AppLogger.debug("Found \(profiles.count) user profiles")
            
            if let profile = profiles.first {
                AppLogger.success("Loading existing user data for: \(profile.userName ?? "Unknown")")
                self.userProfile = profile
                loadFromUserProfile(profile)
            } else {
                AppLogger.info("Creating new user profile with defaults")
                createDefaultUserProfile()
            }
        } catch {
            AppLogger.error("Error loading user data: \(error.localizedDescription)")
            createDefaultUserProfile()
        }
    }
    
    private func createDefaultUserProfile() {
        AppLogger.debug("Creating default user profile...")
        let context = persistentContainer.viewContext
        let profile = UserProfile(context: context)
        
        // Set default values with validation
        profile.userName = InputValidator.validateName("User") ?? "User"
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
            AppLogger.debug("Saving context - changes detected")
            do {
                try context.save()
                AppLogger.success("Context saved successfully")
            } catch {
                AppLogger.error("Error saving context: \(error.localizedDescription)")
            }
        } else {
            AppLogger.debug("No changes to save")
        }
    }
    
    private func saveUserProfile() {
        guard let profile = userProfile else { 
            AppLogger.warning("No userProfile to save!")
            return 
        }
        
        AppLogger.debug("Saving user profile...")
        
        // Validate and sanitize input before saving
        profile.userName = InputValidator.validateName(userName) ?? "User"
        profile.onboardingCompleted = !showOnboarding
        profile.severityLevel = max(0.0, min(10.0, severityLevel)) // Clamp severity level
        profile.flareFrequency = InputValidator.validateString(flareFrequency, maxLength: 50, allowEmpty: false) ?? "Weekly"
        
        // Clear existing relationships
        profile.conditions = nil
        profile.symptoms = nil
        profile.triggers = nil
        profile.routines = nil
        profile.goals = nil
        
        // Add new conditions with validation
        AppLogger.debug("Adding \(selectedConditions.count) conditions")
        for conditionName in selectedConditions {
            if let validatedName = InputValidator.validateName(conditionName) {
                let condition = UserCondition(context: persistentContainer.viewContext)
                condition.name = validatedName
                condition.userProfile = profile
            }
        }
        
        // Add new symptoms with validation
        AppLogger.debug("Adding \(selectedSymptoms.count) symptoms")
        for symptomName in selectedSymptoms {
            if let validatedName = InputValidator.validateName(symptomName) {
                let symptom = UserSymptom(context: persistentContainer.viewContext)
                symptom.name = validatedName
                symptom.userProfile = profile
            }
        }
        
        // Add new triggers with validation
        AppLogger.debug("Adding \(selectedTriggers.count) triggers")
        for triggerName in selectedTriggers {
            if let validatedName = InputValidator.validateName(triggerName) {
                let trigger = UserTrigger(context: persistentContainer.viewContext)
                trigger.name = validatedName
                trigger.userProfile = profile
            }
        }
        
        // Add new routines with validation
        AppLogger.debug("Adding \(selectedRoutines.count) routines")
        for routineName in selectedRoutines {
            if let validatedName = InputValidator.validateName(routineName) {
                let routine = UserRoutine(context: persistentContainer.viewContext)
                routine.name = validatedName
                routine.userProfile = profile
            }
        }
        
        // Add new goals with validation
        AppLogger.debug("Adding \(selectedGoals.count) goals")
        for goalName in selectedGoals {
            if let validatedName = InputValidator.validateName(goalName) {
                let goal = UserGoal(context: persistentContainer.viewContext)
                goal.name = validatedName
                goal.userProfile = profile
            }
        }
        
        saveContext()
    }
    
    // MARK: - Methods
    @MainActor
    func completeOnboarding() {
        AppLogger.info("Completing onboarding")
        showOnboarding = false
        currentScreen = .home
        saveUserProfile()
    }
    
    @MainActor
    func resetOnboarding() {
        AppLogger.info("Resetting onboarding")
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
        AppLogger.debug("Saving onboarding data")
        saveUserProfile()
    }
    
    @MainActor
    func navigateTo(_ screen: AppScreen) {
        currentScreen = screen
    }
    
    @MainActor
    func addFoodItem(_ item: FoodItem) {
        // Validate input before adding
        let validation = InputValidator.validateFoodItem(
            name: item.name,
            calories: item.calories,
            mealType: item.mealType
        )
        
        guard let validatedName = validation.name,
              let validatedMealType = validation.mealType else {
            AppLogger.warning("Invalid food item data, skipping save")
            return
        }
        
        let validatedItem = FoodItem(
            name: validatedName,
            calories: validation.calories,
            icon: item.icon,
            color: item.color,
            mealType: validatedMealType
        )
        
        foodItems.append(validatedItem)
        saveFoodItemToCoreData(validatedItem)
    }
    
    @MainActor
    func addMedication(_ medication: MedicationItem) {
        // Validate input before adding
        let validation = InputValidator.validateMedication(
            name: medication.name,
            dosage: medication.dosage,
            frequency: medication.frequency
        )
        
        guard let validatedName = validation.name,
              let validatedDosage = validation.dosage,
              let validatedFrequency = validation.frequency else {
            AppLogger.warning("Invalid medication data, skipping save")
            return
        }
        
        let validatedMedication = MedicationItem(
            name: validatedName,
            dosage: validatedDosage,
            frequency: validatedFrequency,
            icon: medication.icon,
            color: medication.color,
            isTaken: medication.isTaken
        )
        
        medications.append(validatedMedication)
        saveMedicationToCoreData(validatedMedication)
    }
    
    @MainActor
    func toggleMedication(_ medication: MedicationItem) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
            updateMedicationInCoreData(medications[index])
        }
    }
    
    @MainActor
    func addSymptom(_ symptom: SymptomItem) {
        // Validate input before adding
        let validation = InputValidator.validateSymptom(
            name: symptom.name,
            severity: symptom.severity,
            notes: symptom.notes
        )
        
        guard let validatedName = validation.name else {
            AppLogger.warning("Invalid symptom data, skipping save")
            return
        }
        
        let validatedSymptom = SymptomItem(
            name: validatedName,
            severity: validation.severity,
            notes: validation.notes ?? "",
            timestamp: InputValidator.validateDate(symptom.timestamp)
        )
        
        symptoms.append(validatedSymptom)
        saveSymptomToCoreData(validatedSymptom)
    }
    
    @MainActor
    func addSleepLog(_ log: SleepLog) {
        // Validate input before adding
        let validation = InputValidator.validateSleepLog(
            hours: log.sleepHours,
            quality: log.quality,
            notes: log.notes
        )
        
        let validatedLog = SleepLog(
            sleepHours: validation.hours,
            quality: validation.quality,
            notes: validation.notes ?? "",
            date: InputValidator.validateDate(log.date)
        )
        
        sleepLogs.append(validatedLog)
        saveSleepLogToCoreData(validatedLog)
    }
    
    @MainActor
    func addTherapySession(_ session: TherapySession) {
        // Validate input before adding
        let validation = InputValidator.validateTherapySession(
            type: session.type,
            duration: session.duration,
            notes: session.notes
        )
        
        guard let validatedType = validation.type else {
            AppLogger.warning("Invalid therapy session data, skipping save")
            return
        }
        
        let validatedSession = TherapySession(
            type: validatedType,
            duration: validation.duration,
            notes: validation.notes ?? "",
            date: InputValidator.validateDate(session.date)
        )
        
        therapySessions.append(validatedSession)
        saveTherapySessionToCoreData(validatedSession)
    }
    
    // MARK: - CoreData Save Methods
    @MainActor
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
    
    @MainActor
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
    
    @MainActor
    private func updateMedicationInCoreData(_ medication: MedicationItem) {
        // This would need to be implemented based on how you want to match medications
        // For now, we'll just save the context
        saveContext()
    }
    
    @MainActor
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
    
    @MainActor
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

    @MainActor
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

    @MainActor
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
        
        saveContext()
    }

    @MainActor
    func getTimelineEntriesForDate(_ date: Date) -> [TimelineEntryModel] {
        let calendar = Calendar.current
        return timelineEntries.filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
    }
    
    @MainActor
    func deleteMedication(_ medication: MedicationItem) {
        medications.removeAll { $0.id == medication.id }
        saveOnboardingData()
    }
}