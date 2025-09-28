//
//  RestTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct RestTrackingView: View {
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
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text("Rest Tracking")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                Spacer()
                
                Text("Rest Tracking")
                    .font(.title)
                    .foregroundColor(.primary)
                
                Text("Monitor your sleep and rest patterns")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}