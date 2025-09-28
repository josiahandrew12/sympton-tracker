//
//  ProfileSetupView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 16) {
                Text("What's your name?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("We'll personalize your experience")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            
            // Name input
            TextField("Enter your name", text: $stateManager.userName)
                .font(.system(size: 18, weight: .regular))
                .focused($isTextFieldFocused)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isTextFieldFocused ? Color.blue : Color.clear, lineWidth: 2)
                        )
                )
                .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}