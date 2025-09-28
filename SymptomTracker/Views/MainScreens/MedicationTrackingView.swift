//
//  MedicationTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct MedicationTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                        // Add medication action
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                Spacer()
                
                Text("Medication Tracking")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Track your medications and dosages")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.black)
        }
    }
}