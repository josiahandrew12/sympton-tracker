//
//  TherapyTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct TherapyTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var selectedTherapyType = "Mental"
    
    private let therapyTypes = ["Mental", "Physical"]
    
    private func therapyEmoji(for type: String) -> String {
        switch type {
        case "Mental": return "🧠"
        case "Physical": return "💪"
        default: return "🧠"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
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
                        Text("Select Therapy Type")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            ForEach(therapyTypes, id: \.self) { therapyType in
                                Button(action: {
                                    selectedTherapyType = therapyType
                                    // Save immediately to timeline
                                    stateManager.addTimelineEntry(
                                        type: .therapy,
                                        title: therapyType,
                                        subtitle: "Session logged",
                                        icon: therapyEmoji(for: therapyType)
                                    )
                                }) {
                                    HStack(spacing: 16) {
                                        Text(therapyEmoji(for: therapyType))
                                            .font(.system(size: 40))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(therapyType) Therapy")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text("Tap to log session")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.black)
        }
    }
}