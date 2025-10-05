//
//  TherapyTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct TherapyTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var selectedTherapyType: TherapyType = .mental
    @State private var duration: Double = 30
    @State private var notes: String = ""
    
    enum TherapyType: String, CaseIterable {
        case mental = "Mental"
        case physical = "Physical"
        
        var emoji: String {
            switch self {
            case .mental: return "🧠"
            case .physical: return "💪"
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Button(action: {
                                stateManager.navigateTo(.home)
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Text("Therapy Tracking")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Empty space for symmetry
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                        
                        // Therapy Type Selection
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Therapy Type")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            HStack(spacing: 12) {
                                ForEach(TherapyType.allCases, id: \.self) { type in
                                    Button(action: {
                                        selectedTherapyType = type
                                    }) {
                                        HStack {
                                            Text(type.emoji)
                                                .font(.system(size: 20))
                                            Text(type.rawValue)
                                                .font(.system(size: 14, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule()
                                                .fill(selectedTherapyType == type ? Color.orange : Color.gray.opacity(0.3))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 24)
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Duration")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 12) {
                                Text("\(Int(duration)) minutes")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Slider(value: $duration, in: 15...120, step: 15)
                                    .tint(.orange)
                                    .padding(.horizontal, 24)
                            }
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 24)
                        
                        // Notes (Optional)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Notes (Optional)")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(12)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 120)
                    }
                }
                .background(Color.black)
                
                // Save Button
                VStack {
                    Spacer()
                    Button(action: {
                        stateManager.addTimelineEntry(
                            type: .therapy,
                            title: selectedTherapyType.rawValue,
                            subtitle: "\(Int(duration)) minutes",
                            icon: selectedTherapyType.emoji
                        )
                        stateManager.navigateTo(.home)
                    }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .background(
                        Color.black.opacity(0.95)
                            .ignoresSafeArea()
                    )
                }
            }
        }
    }
}