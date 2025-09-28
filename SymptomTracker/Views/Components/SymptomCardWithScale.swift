//
//  SymptomCardWithScale.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct SymptomCardWithScale: View {
    let symptom: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let severity: Double
    let onTap: () -> Void
    let onSeverityChange: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Main symptom card
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? color.opacity(0.2) : color.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(isSelected ? color : color.opacity(0.7))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(symptom)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Symptom")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(isSelected ? color : Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(color)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .shadow(color: .white.opacity(0.1), radius: 6, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Individual severity scale (only show if selected)
            if isSelected {
                VStack(spacing: 8) {
                    HStack {
                        Text("Severity")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(severity))/10")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(color)
                    }
                    
                    Slider(value: Binding(
                        get: { severity },
                        set: { onSeverityChange($0) }
                    ), in: 1...10, step: 1)
                        .accentColor(color)
                    
                    HStack {
                        Text("Mild")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("Severe")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(color.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
    }
}
