//
//  TherapyTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct TherapyTrackingView: View {
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
                    
                    Text("Therapy Tracking")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                Spacer()
                
                Text("Therapy Tracking")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Track your therapy sessions and mental health")
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