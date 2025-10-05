//
//  RestTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct RestTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var selectedRestType = "Nighttime Rest"
    
    private let restTypes = ["Nighttime Rest", "Nap"]
    
    private func restEmoji(for type: String) -> String {
        switch type {
        case "Nighttime Rest": return "😴"
        case "Nap": return "💤"
        default: return "😴"
        }
    }
    
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
                        
                        Text("Rest Tracking")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Empty space for symmetry
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Rest Type Selection
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Select Rest Type")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            ForEach(restTypes, id: \.self) { restType in
                                Button(action: {
                                    selectedRestType = restType
                                    // Save immediately to timeline
                                    stateManager.addTimelineEntry(
                                        type: .rest,
                                        title: restType,
                                        subtitle: "Logged at \(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))",
                                        icon: restEmoji(for: restType)
                                    )
                                }) {
                                    HStack(spacing: 16) {
                                        Text(restEmoji(for: restType))
                                            .font(.system(size: 40))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(restType)
                                                .font(.system(size: 18, weight: .semibold))
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
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.black)
        }
    }
}