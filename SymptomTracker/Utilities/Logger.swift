//
//  Logger.swift
//  SymptomTracker
//
//  Production-ready logging system that only logs in DEBUG builds
//

import Foundation
import os.log

/// Production-ready logger that only logs in DEBUG builds
/// Uses OSLog for better performance and integration with system logging
struct AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.symptomtracker"
    private static let category = "SymptomTracker"
    
    private static let logger = os.Logger(subsystem: subsystem, category: category)
    
    // MARK: - Logging Methods
    
    /// Logs an info message (only in DEBUG builds)
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger.info("ℹ️ [\(fileName):\(line)] \(function): \(message)")
        #endif
    }
    
    /// Logs a warning message (only in DEBUG builds)
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger.warning("⚠️ [\(fileName):\(line)] \(function): \(message)")
        #else
        // In production, log warnings to system
        logger.warning("\(message)")
        #endif
    }
    
    /// Logs an error message (always logged, even in production)
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        #if DEBUG
        logger.error("❌ [\(fileName):\(line)] \(function): \(message)")
        #else
        logger.error("\(message)")
        #endif
    }
    
    /// Logs a success message (only in DEBUG builds)
    static func success(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger.info("✅ [\(fileName):\(line)] \(function): \(message)")
        #endif
    }
    
    /// Logs debug information (only in DEBUG builds)
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger.debug("🔍 [\(fileName):\(line)] \(function): \(message)")
        #endif
    }
}

