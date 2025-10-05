//
//  TimelineView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct TimelineView: View {
    let entries: [TimelineEntryModel]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Timeline")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 24)

            if entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.5))

                    Text("No activities tracked today")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))

                    Text("Start tracking your symptoms, medications, and activities")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(entries) { entry in
                        TimelineEntryCard(entry: entry)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct TimelineEntryCard: View {
    let entry: TimelineEntryModel

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        HStack(spacing: 16) {
            // Emoji and time
            VStack(spacing: 4) {
                Text(entry.icon)
                    .font(.system(size: 20))

                Text(timeFormatter.string(from: entry.timestamp))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(width: 50)

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Text(entry.type.displayName.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(colorForType(entry.type))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(colorForType(entry.type).opacity(0.2))
                        )
                }

                Text(entry.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }

    private func colorForType(_ type: TimelineEntryType) -> Color {
        switch type {
        case .medication:
            return .blue
        case .symptom:
            return .red
        case .food:
            return .green
        case .rest:
            return .orange
        case .therapy:
            return .purple
        }
    }
}