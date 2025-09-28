//
//  SymptomsView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct SymptomsView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var symptomSeverities: [String: Double] = [:]
    
    private let symptoms = [
        ("Fatigue", "zzz", Color.orange),
        ("Pain", "bandage.fill", Color.red),
        ("Brain Fog", "brain.head.profile", Color.purple),
        ("Nausea", "stomach.fill", Color.green),
        ("Headache", "bolt.fill", Color.yellow),
        ("Dizziness", "arrow.triangle.2.circlepath", Color.blue),
        ("Anxiety", "heart.fill", Color.pink),
        ("Sleep Issues", "moon.fill", Color.indigo)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Track Your Symptoms")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Select symptoms you experience regularly")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Symptoms with individual scales
            VStack(spacing: 16) {
                ForEach(symptoms, id: \.0) { symptom in
                    SymptomCardWithScale(
                        symptom: symptom.0,
                        icon: symptom.1,
                        color: symptom.2,
                        isSelected: stateManager.selectedSymptoms.contains(symptom.0),
                        severity: symptomSeverities[symptom.0] ?? 5.0,
                        onTap: {
                            if stateManager.selectedSymptoms.contains(symptom.0) {
                                stateManager.selectedSymptoms.remove(symptom.0)
                                symptomSeverities.removeValue(forKey: symptom.0)
                            } else {
                                stateManager.selectedSymptoms.insert(symptom.0)
                                symptomSeverities[symptom.0] = 5.0
                            }
                        },
                        onSeverityChange: { newValue in
                            symptomSeverities[symptom.0] = newValue
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}