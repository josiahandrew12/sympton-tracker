//
//  TreatmentsView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct TreatmentsView: View {
    @State private var selectedTreatments: Set<String> = []
    
    private let treatments = [
        ("Medications", "pills.fill"),
        ("Supplements", "leaf.fill"),
        ("Diet Restrictions", "fork.knife"),
        ("Physical Therapy", "figure.walk"),
        ("Mental Health Therapy", "brain.head.profile"),
        ("Alternative Medicine", "leaf.circle.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Current Treatments")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("What treatments or supports are you currently using?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Treatment options
            VStack(spacing: 12) {
                ForEach(treatments, id: \.0) { treatment in
                    TreatmentCard(
                        treatment: treatment.0,
                        icon: treatment.1,
                        isSelected: selectedTreatments.contains(treatment.0),
                        onTap: {
                            if selectedTreatments.contains(treatment.0) {
                                selectedTreatments.remove(treatment.0)
                            } else {
                                selectedTreatments.insert(treatment.0)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}