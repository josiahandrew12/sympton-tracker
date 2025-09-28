//
//  ErrorHandling.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import Foundation
import CoreData

// MARK: - App Error Types
enum AppError: LocalizedError {
    case coreDataError(String)
    case networkError(String)
    case validationError(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .coreDataError(let message):
            return "Database Error: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .unknownError(let message):
            return "Unknown Error: \(message)"
        }
    }
}

// MARK: - Result Type for Better Error Handling
typealias AppResult<T> = Result<T, AppError>

// MARK: - CoreData Error Handling
extension PersistenceController {
    /// Safely perform CoreData operations with error handling
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async -> AppResult<T> {
        return await withCheckedContinuation { continuation in
            container.performBackgroundTask { context in
                do {
                    let result = try block(context)
                    if context.hasChanges {
                        try context.save()
                    }
                    continuation.resume(returning: .success(result))
                } catch {
                    let appError = AppError.coreDataError(error.localizedDescription)
                    continuation.resume(returning: .failure(appError))
                }
            }
        }
    }
    
    /// Safely perform CoreData operations on main context
    func performMainTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) -> AppResult<T> {
        let context = container.viewContext
        do {
            let result = try block(context)
            if context.hasChanges {
                try context.save()
            }
            return .success(result)
        } catch {
            let appError = AppError.coreDataError(error.localizedDescription)
            return .failure(appError)
        }
    }
}

// MARK: - View Extensions for Error Handling
extension View {
    /// Show error alert with proper error handling
    func errorAlert(error: Binding<AppError?>) -> some View {
        self.alert("Error", isPresented: .constant(error.wrappedValue != nil)) {
            Button("OK") {
                error.wrappedValue = nil
            }
        } message: {
            if let errorMessage = error.wrappedValue?.localizedDescription {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - Logging Utilities
struct Logger {
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("ℹ️ [\(fileName):\(line)] \(function): \(message)")
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("⚠️ [\(fileName):\(line)] \(function): \(message)")
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("❌ [\(fileName):\(line)] \(function): \(message)")
    }
    
    static func success(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("✅ [\(fileName):\(line)] \(function): \(message)")
    }
}
