//
//  WelcomeView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Main welcome content
            VStack(spacing: 24) {
                // Title and description
                VStack(spacing: 16) {
                    Text("Welcome to")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text("SymptomTracker")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("AI-powered chronic illness tracking and health insights")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            // Features preview
            VStack(spacing: 16) {
                Text("What you'll get")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 12) {
                    FeaturePreviewRow(
                        icon: "brain.head.profile",
                        title: "AI-Powered Flare Tracking",
                        description: "Intelligent pattern recognition for your symptoms",
                        color: .purple
                    )
                    
                    FeaturePreviewRow(
                        icon: "heart.text.square.fill",
                        title: "Track All Aspects",
                        description: "Monitor every aspect of your chronic illness",
                        color: .red
                    )
                    
                    FeaturePreviewRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Health Insights",
                        description: "Personalized recommendations and predictions",
                        color: .blue
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}