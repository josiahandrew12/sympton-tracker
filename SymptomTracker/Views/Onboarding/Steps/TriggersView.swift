//
//  TriggersView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct TriggersView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    private let triggers = [
        ("Diet", "fork.knife", Color.orange),
        ("Stress", "exclamationmark.triangle.fill", Color.red),
        ("Sleep", "moon.fill", Color.indigo),
        ("Movement", "figure.walk", Color.blue),
        ("Hormones", "waveform.path.ecg", Color.pink),
        ("Environment", "cloud.sun.fill", Color.yellow)
    ]
    
    private let routines = [
        ("Sleep", "moon.fill"),
        ("Exercise", "figure.walk"),
        ("Meals", "fork.knife"),
        ("Stress", "exclamationmark.triangle.fill"),
        ("All of the above", "checkmark.circle.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Triggers & Routines")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("What would you like to track for insights?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Triggers section
            VStack(alignment: .leading, spacing: 16) {
                Text("Triggers to Track")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 12) {
                    ForEach(triggers, id: \.0) { trigger in
                        TriggerCardFullWidth(
                            trigger: trigger.0,
                            icon: trigger.1,
                            color: trigger.2,
                            isSelected: stateManager.selectedTriggers.contains(trigger.0),
                            onTap: {
                                if stateManager.selectedTriggers.contains(trigger.0) {
                                    stateManager.selectedTriggers.remove(trigger.0)
                                } else {
                                    stateManager.selectedTriggers.insert(trigger.0)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            // Routines section
            VStack(alignment: .leading, spacing: 16) {
                Text("Things You Want to Track")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 12) {
                    ForEach(routines, id: \.0) { routine in
                        RoutineCard(
                            routine: routine.0,
                            icon: routine.1,
                            isSelected: stateManager.selectedRoutines.contains(routine.0),
                            onTap: {
                                if stateManager.selectedRoutines.contains(routine.0) {
                                    stateManager.selectedRoutines.remove(routine.0)
                                } else {
                                    stateManager.selectedRoutines.insert(routine.0)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}