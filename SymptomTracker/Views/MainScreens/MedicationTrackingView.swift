//
//  MedicationTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct MedicationTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var showingAddMedication = false
    @State private var newMedicationName = ""
    @State private var newMedicationDosage = ""
    @State private var newMedicationFrequency = "Daily"
    @State private var commonMedications: [MedicationItem] = [
        MedicationItem(name: "Ibuprofen", dosage: "200mg", frequency: "As needed", icon: "💊", color: .blue),
        MedicationItem(name: "Acetaminophen", dosage: "500mg", frequency: "Every 6 hours", icon: "💊", color: .red),
        MedicationItem(name: "Vitamin D", dosage: "1000 IU", frequency: "Daily", icon: "💊", color: .orange),
        MedicationItem(name: "Multivitamin", dosage: "1 tablet", frequency: "Daily", icon: "💊", color: .green)
    ]
    @State private var todaysMedications: [MedicationItem] = []
    
    private let frequencies = ["Daily", "Twice daily", "Every 6 hours", "As needed", "Weekly"]
    
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
                        
                        Text("Medication Tracking")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddMedication = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Today's Medications Section
                    if !todaysMedications.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Today's Medications")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 12) {
                                ForEach(todaysMedications) { medication in
                                    MedicationTrackCard(medication: medication) {
                                        // Save medication
                                        stateManager.addTimelineEntry(
                                            type: .medication,
                                            title: medication.name,
                                            subtitle: "\(medication.dosage) - \(medication.frequency)",
                                            icon: "💊"
                                        )
                                        // Remove from today's list
                                        todaysMedications.removeAll { $0.id == medication.id }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 24)
                    }
                    
                    // Common Medications Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Common Medications")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            ForEach(commonMedications) { medication in
                                CommonMedicationCard(medication: medication) {
                                    // Add to today's medications
                                    if !todaysMedications.contains(where: { $0.id == medication.id }) {
                                        todaysMedications.append(medication)
                                    }
                                } onDelete: {
                                    commonMedications.removeAll { $0.id == medication.id }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(Color.black)
        }
        .sheet(isPresented: $showingAddMedication) {
            NavigationView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medication Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            TextField("Enter medication name", text: $newMedicationName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dosage")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            TextField("e.g., 200mg", text: $newMedicationDosage)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            Picker("Frequency", selection: $newMedicationFrequency) {
                                ForEach(frequencies, id: \.self) { freq in
                                    Text(freq).tag(freq)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.blue)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.top, 24)
                .navigationTitle("Add Medication")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            newMedicationName = ""
                            newMedicationDosage = ""
                            newMedicationFrequency = "Daily"
                            showingAddMedication = false
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            let newMed = MedicationItem(
                                name: newMedicationName,
                                dosage: newMedicationDosage,
                                frequency: newMedicationFrequency,
                                icon: "💊",
                                color: .blue
                            )
                            commonMedications.append(newMed)
                            newMedicationName = ""
                            newMedicationDosage = ""
                            newMedicationFrequency = "Daily"
                            showingAddMedication = false
                        }
                        .disabled(newMedicationName.isEmpty || newMedicationDosage.isEmpty)
                    }
                }
            }
        }
    }
}

struct MedicationTrackCard: View {
    let medication: MedicationItem
    let onSave: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text("💊")
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(medication.dosage) - \(medication.frequency)")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: onSave) {
                Text("Save")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue)
                    )
            }
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
}

struct CommonMedicationCard: View {
    let medication: MedicationItem
    let onAdd: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text("💊")
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(medication.dosage) - \(medication.frequency)")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.red.opacity(0.7))
            }
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
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
}