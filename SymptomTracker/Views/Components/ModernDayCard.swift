//
//  ModernDayCard.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct ModernDayCard: View {
    let day: Int
    let isSelected: Bool
    
    private let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let dayNumbers = ["15", "16", "17", "18", "19", "20", "21"]
    
    var body: some View {
        VStack(spacing: 10) {
            Text(dayNames[day])
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(dayNumbers[day])
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                )
        }
        .frame(width: 56)
        .padding(.vertical, 8)
    }
}