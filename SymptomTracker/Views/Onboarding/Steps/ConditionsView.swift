//
//  ConditionsView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct ConditionsView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    private let conditions = [
        ("Functional neurological disorder", "brain.head.profile"),
        ("Autonomic dysfunction", "heart.fill"),
        ("Chronic Pain", "bandage.fill"),
        ("Fibromyalgia", "figure.walk"),
        ("Arthritis", "figure.arms.open"),
        ("Migraine", "bolt.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Your Chronic Illness")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Select any conditions you're managing")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Conditions grid
            VStack(spacing: 12) {
                ForEach(conditions, id: \.0) { condition in
                    ConditionCard(
                        condition: condition.0,
                        icon: condition.1,
                        isSelected: stateManager.selectedConditions.contains(condition.0),
                        onTap: {
                            if stateManager.selectedConditions.contains(condition.0) {
                                stateManager.selectedConditions.remove(condition.0)
                            } else {
                                stateManager.selectedConditions.insert(condition.0)
                            }
                        }
                    )
                }
                
                // Add custom condition
                Button(action: {
                    // Add custom condition functionality
                }) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add another condition")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Tap to add a custom condition")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                            .shadow(color: .white.opacity(0.1), radius: 6, x: 0, y: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}