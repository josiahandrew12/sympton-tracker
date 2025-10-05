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
    var id = UUID()
    let name: String
    let calories: Int
    let icon: String
    let color: Color
    let mealType: String

    init(name: String, calories: Int, icon: String, color: Color, mealType: String = "Breakfast") {
        self.name = name
        self.calories = calories
        self.icon = icon
        self.color = color
        self.mealType = mealType
    }

    enum CodingKeys: String, CodingKey {
        case id, name, calories, icon, mealType, colorData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(Int.self, forKey: .calories)
        icon = try container.decode(String.self, forKey: .icon)
        mealType = try container.decode(String.self, forKey: .mealType)

        if let colorData = try container.decodeIfPresent(Data.self, forKey: .colorData) {
            color = Color.fromData(colorData) ?? .red
        } else {
            color = .red
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(calories, forKey: .calories)
        try container.encode(icon, forKey: .icon)
        try container.encode(mealType, forKey: .mealType)
        try container.encode(color.toData(), forKey: .colorData)
    }
}

// MARK: - Medication Item Model
struct MedicationItem: Identifiable, Codable {
    var id = UUID()
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

    enum CodingKeys: String, CodingKey {
        case id, name, dosage, frequency, icon, isTaken, colorData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        dosage = try container.decode(String.self, forKey: .dosage)
        frequency = try container.decode(String.self, forKey: .frequency)
        icon = try container.decode(String.self, forKey: .icon)
        isTaken = try container.decode(Bool.self, forKey: .isTaken)

        if let colorData = try container.decodeIfPresent(Data.self, forKey: .colorData) {
            color = Color.fromData(colorData) ?? .blue
        } else {
            color = .blue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dosage, forKey: .dosage)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(icon, forKey: .icon)
        try container.encode(isTaken, forKey: .isTaken)
        try container.encode(color.toData(), forKey: .colorData)
    }
}

// MARK: - Symptom Item Model
struct SymptomItem: Identifiable, Codable {
    var id = UUID()
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
    var id = UUID()
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
    var id = UUID()
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

// MARK: - Timeline Entry Model
struct TimelineEntryModel: Identifiable, Codable {
    var id = UUID()
    let type: TimelineEntryType
    let title: String
    let subtitle: String
    let icon: String
    let timestamp: Date
    let data: Data?

    init(type: TimelineEntryType, title: String, subtitle: String, icon: String, timestamp: Date = Date(), data: Data? = nil) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.timestamp = timestamp
        self.data = data
    }
}

// MARK: - Timeline Entry Type Enum
enum TimelineEntryType: String, CaseIterable, Codable {
    case symptom = "symptom"
    case medication = "medication"
    case food = "food"
    case therapy = "therapy"
    case rest = "rest"

    var displayName: String {
        switch self {
        case .symptom:
            return "Symptom"
        case .medication:
            return "Medication"
        case .food:
            return "Food"
        case .therapy:
            return "Therapy"
        case .rest:
            return "Rest"
        }
    }

    var color: Color {
        switch self {
        case .symptom:
            return .red
        case .medication:
            return .blue
        case .food:
            return .green
        case .therapy:
            return .purple
        case .rest:
            return .orange
        }
    }
}