//
//  AppStateManager.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

class AppStateManager: ObservableObject {
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
    
    // MARK: - Methods
    func completeOnboarding() {
        showOnboarding = false
        currentScreen = .home
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
    }
    
    func navigateTo(_ screen: AppScreen) {
        currentScreen = screen
    }
    
    func addFoodItem(_ item: FoodItem) {
        foodItems.append(item)
    }
    
    func addMedication(_ medication: MedicationItem) {
        medications.append(medication)
    }
    
    func toggleMedication(_ medication: MedicationItem) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
        }
    }
    
    func addSymptom(_ symptom: SymptomItem) {
        symptoms.append(symptom)
    }
    
    func addSleepLog(_ log: SleepLog) {
        sleepLogs.append(log)
    }
    
    func addTherapySession(_ session: TherapySession) {
        therapySessions.append(session)
    }
}