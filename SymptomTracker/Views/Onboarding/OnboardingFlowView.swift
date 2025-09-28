//
//  OnboardingFlowView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var stateManager: AppStateManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress indicator
                    VStack(spacing: 16) {
                        HStack(spacing: 8) {
                            ForEach(0..<9, id: \.self) { step in
                                Circle()
                                    .fill(step <= stateManager.currentStep ? Color.blue : Color.white.opacity(0.3))
                                    .frame(width: 10, height: 10)
                                    .scaleEffect(step == stateManager.currentStep ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: stateManager.currentStep)
                            }
                        }
                        
                        Text("Step \(stateManager.currentStep + 1) of 9")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Current step content
                    ScrollView {
                        VStack(spacing: 0) {
                            switch stateManager.currentStep {
                            case 0:
                                WelcomeView()
                            case 1:
                                ProfileSetupView()
                            case 2:
                                ConditionsView()
                            case 3:
                                SymptomsView()
                            case 4:
                                FlarePatternView()
                            case 5:
                                TreatmentsView()
                            case 6:
                                TriggersView()
                            case 7:
                                GoalsView()
                            case 8:
                                OnboardingSummaryView()
                            default:
                                WelcomeView()
                            }
                        }
                    }
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if stateManager.currentStep > 0 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    stateManager.currentStep -= 1
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.blue.opacity(0.1))
                                    )
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if stateManager.currentStep < 8 {
                                    stateManager.currentStep += 1
                                } else {
                                    // Complete onboarding
                                    stateManager.completeOnboarding()
                                }
                            }
                        }) {
                            HStack(spacing: 8) {
                                if stateManager.currentStep == 8 {
                                    Text("Get Started")
                                        .font(.system(size: 16, weight: .semibold))
                                } else {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}