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
    @State private var customSymptom = ""
    @State private var showingAddCustom = false
    
    private let symptoms = [
        ("Fatigue", "zzz", Color.orange),
        ("Pain", "bandage.fill", Color.red),
        ("Brain Fog", "brain.head.profile", Color.purple),
        ("Nausea", "heart.fill", Color.green),
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
                    .foregroundColor(.white)
                
                Text("Select symptoms you experience regularly")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
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
                            stateManager.saveOnboardingData()
                        },
                        onSeverityChange: { newValue in
                            symptomSeverities[symptom.0] = newValue
                            stateManager.saveOnboardingData()
                        }
                    )
                }

                // Custom symptoms from the user
                ForEach(Array(stateManager.selectedSymptoms.subtracting(symptoms.map { $0.0 })), id: \.self) { customSymptom in
                    SymptomCardWithScale(
                        symptom: customSymptom,
                        icon: "plus.circle",
                        color: .gray,
                        isSelected: true,
                        severity: symptomSeverities[customSymptom] ?? 5.0,
                        onTap: {
                            stateManager.selectedSymptoms.remove(customSymptom)
                            symptomSeverities.removeValue(forKey: customSymptom)
                            stateManager.saveOnboardingData()
                        },
                        onSeverityChange: { newValue in
                            symptomSeverities[customSymptom] = newValue
                            stateManager.saveOnboardingData()
                        }
                    )
                }

                // Add Custom Symptom Button
                Button(action: {
                    showingAddCustom = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)

                        Text("Add Custom Symptom")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)

                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .sheet(isPresented: $showingAddCustom) {
            NavigationView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Custom Symptom")
                            .font(.headline)
                            .foregroundColor(.primary)

                        TextField("Enter symptom name...", text: $customSymptom)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
                .padding(.top, 24)
                .navigationTitle("Add Symptom")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            customSymptom = ""
                            showingAddCustom = false
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            if !customSymptom.isEmpty {
                                stateManager.selectedSymptoms.insert(customSymptom)
                                symptomSeverities[customSymptom] = 5.0
                                stateManager.saveOnboardingData()
                                customSymptom = ""
                                showingAddCustom = false
                            }
                        }
                        .disabled(customSymptom.isEmpty)
                    }
                }
            }
        }
    }
}