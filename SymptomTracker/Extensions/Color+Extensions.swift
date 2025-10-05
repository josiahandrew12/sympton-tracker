//
//  Color+Extensions.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import Foundation

extension Color {
    // Convert Color to Data for CoreData storage
    func toData() -> Data {
        let uiColor = UIColor(self)
        return (try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)) ?? Data()
    }
    
    // Create Color from Data stored in CoreData
    static func fromData(_ data: Data) -> Color? {
        guard let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor else {
            return nil
        }
        return Color(uiColor)
    }
    
    // Default colors for fallback
    static let defaultRed = Color.red
    static let defaultBlue = Color.blue
    static let defaultGreen = Color.green
    static let defaultOrange = Color.orange
    static let defaultPurple = Color.purple
    static let defaultYellow = Color.yellow
    static let defaultGray = Color.gray
    static let defaultBrown = Color.brown
}

