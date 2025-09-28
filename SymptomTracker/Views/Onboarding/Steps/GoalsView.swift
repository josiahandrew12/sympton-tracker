//
//  GoalsView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    private let goals = [
        ("Discover flare triggers", "magnifyingglass.circle.fill"),
        ("Reduce symptom severity", "arrow.down.circle.fill"),
        ("Track treatment effectiveness", "chart.line.uptrend.xyaxis"),
        ("Share data with doctors", "square.and.arrow.up.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Your Goals")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("What do you want most from this app?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Goals options
            VStack(spacing: 12) {
                ForEach(goals, id: \.0) { goal in
                    GoalCard(
                        goal: goal.0,
                        icon: goal.1,
                        isSelected: stateManager.selectedGoals.contains(goal.0),
                        onTap: {
                            if stateManager.selectedGoals.contains(goal.0) {
                                stateManager.selectedGoals.remove(goal.0)
                            } else {
                                stateManager.selectedGoals.insert(goal.0)
                            }
                            stateManager.saveOnboardingData()
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}