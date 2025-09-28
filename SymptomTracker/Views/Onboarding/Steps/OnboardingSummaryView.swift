//
//  OnboardingSummaryView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct OnboardingSummaryView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Review Your Setup")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Let's make sure everything looks good")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Summary content
            ScrollView {
                VStack(spacing: 20) {
                    // Profile summary
                    SummarySection(
                        title: "Profile",
                        icon: "person.fill",
                        color: .blue
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(stateManager.userName.isEmpty ? "Not provided" : stateManager.userName)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Conditions summary
                    if !stateManager.selectedConditions.isEmpty {
                        SummarySection(
                            title: "Chronic Illness",
                            icon: "heart.fill",
                            color: .red
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(stateManager.selectedConditions), id: \.self) { condition in
                                    Text("• \(condition)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                    }
                    
                    // Symptoms summary
                    if !stateManager.selectedSymptoms.isEmpty {
                        SummarySection(
                            title: "Symptoms",
                            icon: "bandage.fill",
                            color: .orange
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(stateManager.selectedSymptoms), id: \.self) { symptom in
                                    Text("• \(symptom)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                    }
                    
                    // Flare pattern summary
                    SummarySection(
                        title: "Flare Pattern",
                        icon: "waveform.path.ecg",
                        color: .purple
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• \(stateManager.flareFrequency.isEmpty ? "Not selected" : stateManager.flareFrequency)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Triggers summary
                    if !stateManager.selectedTriggers.isEmpty {
                        SummarySection(
                            title: "Triggers to Track",
                            icon: "exclamationmark.triangle.fill",
                            color: .yellow
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(stateManager.selectedTriggers), id: \.self) { trigger in
                                    Text("• \(trigger)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                    }
                    
                    // Routines summary
                    if !stateManager.selectedRoutines.isEmpty {
                        SummarySection(
                            title: "Routines to Track",
                            icon: "checkmark.circle.fill",
                            color: .green
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(stateManager.selectedRoutines), id: \.self) { routine in
                                    Text("• \(routine)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                    }
                    
                    // Goals summary
                    if !stateManager.selectedGoals.isEmpty {
                        SummarySection(
                            title: "Goals",
                            icon: "target",
                            color: .purple
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(stateManager.selectedGoals), id: \.self) { goal in
                                    Text("• \(goal)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
        }
    }
}