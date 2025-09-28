//
//  FlarePatternView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct FlarePatternView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    private let patterns = [
        ("Episodic", "waveform.path.ecg", "Symptoms flare up periodically"),
        ("Constant", "line.horizontal.3", "Symptoms are always present"),
        ("Variable", "arrow.up.arrow.down", "Symptoms change unpredictably")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Flare Patterns")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("How do your symptoms typically behave?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Pattern options
            VStack(spacing: 12) {
                ForEach(patterns, id: \.0) { pattern in
                    FlarePatternCard(
                        title: pattern.0,
                        icon: pattern.1,
                        description: pattern.2,
                        isSelected: stateManager.flareFrequency == pattern.0,
                        onTap: {
                            stateManager.flareFrequency = pattern.0
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}