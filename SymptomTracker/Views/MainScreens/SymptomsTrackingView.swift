//
//  SymptomsTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct SymptomsTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var showingAddSymptom = false
    @State private var newSymptomName = ""
    @State private var expandedSymptom: String?
    @State private var symptomSeverities: [String: Double] = [:]
    
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
                            
                            Text("Symptoms Tracking")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddSymptom = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                        
                        // Your Symptoms (from onboarding)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Symptoms")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            if stateManager.selectedSymptoms.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "heart.text.square")
                                        .font(.system(size: 40, weight: .light))
                                        .foregroundColor(.white.opacity(0.3))
                                    
                                    Text("No symptoms configured")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.5))
                                    
                                    Text("Add symptoms to track your health")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(Array(stateManager.selectedSymptoms), id: \.self) { symptom in
                                        SymptomLogCardWithScale(
                                            symptom: symptom,
                                            isExpanded: expandedSymptom == symptom,
                                            severity: symptomSeverities[symptom] ?? 5.0,
                                            onToggle: {
                                                withAnimation {
                                                    if expandedSymptom == symptom {
                                                        expandedSymptom = nil
                                                    } else {
                                                        expandedSymptom = symptom
                                                        if symptomSeverities[symptom] == nil {
                                                            symptomSeverities[symptom] = 5.0
                                                        }
                                                    }
                                                }
                                            },
                                            onSeverityChange: { newValue in
                                                symptomSeverities[symptom] = newValue
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                }
                .background(Color.black)
                
                // Save Button (only when symptom is expanded)
                if expandedSymptom != nil {
                    VStack {
                        Spacer()
                        Button(action: {
                            if let symptom = expandedSymptom {
                                let severity = symptomSeverities[symptom] ?? 5.0
                                stateManager.addTimelineEntry(
                                    type: .symptom,
                                    title: symptom,
                                    subtitle: "Severity: \(Int(severity))/10",
                                    icon: "🩺"
                                )
                                expandedSymptom = nil
                                symptomSeverities.removeValue(forKey: symptom)
                                stateManager.navigateTo(.home)
                            }
                        }) {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red)
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
        .sheet(isPresented: $showingAddSymptom) {
            NavigationView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Symptom Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        TextField("Enter symptom name", text: $newSymptomName)
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
                            newSymptomName = ""
                            showingAddSymptom = false
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            if !newSymptomName.isEmpty {
                                stateManager.selectedSymptoms.insert(newSymptomName)
                                stateManager.saveOnboardingData()
                                newSymptomName = ""
                                showingAddSymptom = false
                            }
                        }
                        .disabled(newSymptomName.isEmpty)
                    }
                }
            }
        }
    }
}

struct SymptomLogCardWithScale: View {
    let symptom: String
    let isExpanded: Bool
    let severity: Double
    let onToggle: () -> Void
    let onSeverityChange: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    Text("🩺")
                        .font(.system(size: 32))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(symptom)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if !isExpanded {
                            Text("Tap to log")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 12) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Mild")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text("\(Int(severity))/10")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("Severe")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Slider(value: Binding(
                            get: { severity },
                            set: { onSeverityChange($0) }
                        ), in: 1...10, step: 1)
                        .tint(.red)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}