//
//  InputValidator.swift
//  SymptomTracker
//
//  Created for beta release security improvements
//

import Foundation

/// Validates user input before saving to CoreData
struct InputValidator {
    
    // MARK: - String Validation
    
    /// Validates a string input with length constraints
    /// - Parameters:
    ///   - input: The string to validate
    ///   - maxLength: Maximum allowed length (default: 500)
    ///   - allowEmpty: Whether empty strings are allowed (default: false)
    /// - Returns: Validated string or nil if invalid
    static func validateString(_ input: String, maxLength: Int = 500, allowEmpty: Bool = false) -> String? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !allowEmpty && trimmed.isEmpty {
            return nil
        }
        
        if trimmed.count > maxLength {
            return String(trimmed.prefix(maxLength))
        }
        
        // Check for potentially malicious content (basic sanitization)
        if trimmed.contains("\0") { // Null bytes
            return nil
        }
        
        return trimmed
    }
    
    /// Validates a name string (for user names, condition names, etc.)
    static func validateName(_ name: String) -> String? {
        guard let validated = validateString(name, maxLength: 100, allowEmpty: false) else {
            return nil
        }
        
        // Names should not contain control characters
        let controlChars = CharacterSet.controlCharacters
        if validated.rangeOfCharacter(from: controlChars) != nil {
            return nil
        }
        
        return validated
    }
    
    // MARK: - Numeric Validation
    
    /// Validates a severity level (0-10)
    static func validateSeverity(_ severity: Int) -> Int {
        return max(0, min(10, severity))
    }
    
    /// Validates calories (0-10000)
    static func validateCalories(_ calories: Int) -> Int {
        return max(0, min(10000, calories))
    }
    
    /// Validates sleep hours (0-24)
    static func validateSleepHours(_ hours: Double) -> Double {
        return max(0.0, min(24.0, hours))
    }
    
    /// Validates quality rating (0-10)
    static func validateQuality(_ quality: Int) -> Int {
        return max(0, min(10, quality))
    }
    
    /// Validates duration in minutes (0-1440, i.e., 24 hours)
    static func validateDuration(_ duration: Int) -> Int {
        return max(0, min(1440, duration))
    }
    
    // MARK: - Date Validation
    
    /// Validates that a date is not too far in the future
    static func validateDate(_ date: Date) -> Date {
        let maxFutureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let minPastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date()
        
        if date > maxFutureDate {
            return Date()
        }
        
        if date < minPastDate {
            return minPastDate
        }
        
        return date
    }
    
    // MARK: - Food Item Validation
    
    static func validateFoodItem(name: String, calories: Int, mealType: String) -> (name: String?, calories: Int, mealType: String?) {
        let validatedName = validateName(name)
        let validatedCalories = validateCalories(calories)
        let validatedMealType = validateString(mealType, maxLength: 50, allowEmpty: false)
        
        return (validatedName, validatedCalories, validatedMealType)
    }
    
    // MARK: - Medication Validation
    
    static func validateMedication(name: String, dosage: String, frequency: String) -> (name: String?, dosage: String?, frequency: String?) {
        let validatedName = validateName(name)
        let validatedDosage = validateString(dosage, maxLength: 100, allowEmpty: false)
        let validatedFrequency = validateString(frequency, maxLength: 100, allowEmpty: false)
        
        return (validatedName, validatedDosage, validatedFrequency)
    }
    
    // MARK: - Symptom Validation
    
    static func validateSymptom(name: String, severity: Int, notes: String) -> (name: String?, severity: Int, notes: String?) {
        let validatedName = validateName(name)
        let validatedSeverity = validateSeverity(severity)
        let validatedNotes = validateString(notes, maxLength: 1000, allowEmpty: true)
        
        return (validatedName, validatedSeverity, validatedNotes)
    }
    
    // MARK: - Sleep Log Validation
    
    static func validateSleepLog(hours: Double, quality: Int, notes: String) -> (hours: Double, quality: Int, notes: String?) {
        let validatedHours = validateSleepHours(hours)
        let validatedQuality = validateQuality(quality)
        let validatedNotes = validateString(notes, maxLength: 1000, allowEmpty: true)
        
        return (validatedHours, validatedQuality, validatedNotes)
    }
    
    // MARK: - Therapy Session Validation
    
    static func validateTherapySession(type: String, duration: Int, notes: String) -> (type: String?, duration: Int, notes: String?) {
        let validatedType = validateString(type, maxLength: 100, allowEmpty: false)
        let validatedDuration = validateDuration(duration)
        let validatedNotes = validateString(notes, maxLength: 1000, allowEmpty: true)
        
        return (validatedType, validatedDuration, validatedNotes)
    }
}

