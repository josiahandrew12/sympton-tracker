//
//  AppModels.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

// MARK: - App Screen Enum
enum AppScreen: CaseIterable {
    case home
    case foodTracking
    case medicationTracking
    case restTracking
    case therapyTracking
    case symptomsTracking
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .foodTracking:
            return "Food Tracking"
        case .medicationTracking:
            return "Medication Tracking"
        case .restTracking:
            return "Rest Tracking"
        case .therapyTracking:
            return "Therapy Tracking"
        case .symptomsTracking:
            return "Symptoms Tracking"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .foodTracking:
            return "fork.knife"
        case .medicationTracking:
            return "pills.fill"
        case .restTracking:
            return "bed.double.fill"
        case .therapyTracking:
            return "brain.head.profile"
        case .symptomsTracking:
            return "heart.fill"
        }
    }
}

// MARK: - Food Item Model
struct FoodItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let calories: Int
    let icon: String
    let color: Color
    
    init(name: String, calories: Int, icon: String, color: Color) {
        self.name = name
        self.calories = calories
        self.icon = icon
        self.color = color
    }
}

// MARK: - Medication Item Model
struct MedicationItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let dosage: String
    let frequency: String
    let icon: String
    let color: Color
    var isTaken: Bool
    
    init(name: String, dosage: String, frequency: String, icon: String, color: Color, isTaken: Bool = false) {
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.icon = icon
        self.color = color
        self.isTaken = isTaken
    }
}

// MARK: - Symptom Item Model
struct SymptomItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let severity: Int
    let notes: String
    let timestamp: Date
    
    init(name: String, severity: Int, notes: String, timestamp: Date = Date()) {
        self.name = name
        self.severity = severity
        self.notes = notes
        self.timestamp = timestamp
    }
}

// MARK: - Sleep Log Model
struct SleepLog: Identifiable, Codable {
    let id = UUID()
    let sleepHours: Double
    let quality: Int
    let notes: String
    let date: Date
    
    init(sleepHours: Double, quality: Int, notes: String, date: Date = Date()) {
        self.sleepHours = sleepHours
        self.quality = quality
        self.notes = notes
        self.date = date
    }
}

// MARK: - Therapy Session Model
struct TherapySession: Identifiable, Codable {
    let id = UUID()
    let type: String
    let duration: Int
    let notes: String
    let date: Date
    
    init(type: String, duration: Int, notes: String, date: Date = Date()) {
        self.type = type
        self.duration = duration
        self.notes = notes
        self.date = date
    }
}