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
    @State private var selectedSymptom: String?
    @State private var symptomSeverity: Double = 5.0
    @State private var symptomNotes: String = ""
    
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
                                    SymptomLogCard(symptom: symptom) {
                                        selectedSymptom = symptom
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(Color.black)
        }
        .sheet(item: Binding(
            get: { selectedSymptom.map { SymptomSelection(name: $0) } },
            set: { selectedSymptom = $0?.name }
        )) { symptomSelection in
            NavigationView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Severity")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text("Mild")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(Int(symptomSeverity))/10")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("Severe")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $symptomSeverity, in: 1...10, step: 1)
                                .tint(.red)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextEditor(text: $symptomNotes)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.top, 24)
                .navigationTitle("Log \(symptomSelection.name)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            symptomSeverity = 5.0
                            symptomNotes = ""
                            selectedSymptom = nil
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            stateManager.addTimelineEntry(
                                type: .symptom,
                                title: symptomSelection.name,
                                subtitle: "Severity: \(Int(symptomSeverity))/10",
                                icon: "❤️‍🩹"
                            )
                            symptomSeverity = 5.0
                            symptomNotes = ""
                            selectedSymptom = nil
                        }
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

struct SymptomSelection: Identifiable {
    let id = UUID()
    let name: String
}

struct SymptomLogCard: View {
    let symptom: String
    let onLog: () -> Void
    
    var body: some View {
        Button(action: onLog) {
            HStack(spacing: 16) {
                Text("❤️‍🩹")
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(symptom)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Tap to log")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}