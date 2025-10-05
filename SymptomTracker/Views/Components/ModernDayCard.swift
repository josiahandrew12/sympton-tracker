//
//  ModernDayCard.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct ModernDayCard: View {
    let date: Date
    let isSelected: Bool
    let onTap: () -> Void

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }

    private var dayNumberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(dayFormatter.string(from: date))
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))

            Text(dayNumberFormatter.string(from: date))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isSelected ? .white : .white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                )
        }
        .frame(width: 56)
        .padding(.vertical, 8)
        .onTapGesture {
            onTap()
        }
    }
}