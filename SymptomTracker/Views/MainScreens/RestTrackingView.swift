//
//  RestTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct RestTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var selectedRestType: RestType = .nighttime
    @State private var hours: Double = 7
    @State private var quality: RestQuality = .good
    
    enum RestType: String, CaseIterable {
        case nighttime = "Nighttime Rest"
        case nap = "Nap"
        
        var emoji: String {
            switch self {
            case .nighttime: return "😴"
            case .nap: return "💤"
            }
        }
    }
    
    enum RestQuality: String, CaseIterable {
        case poor = "Poor"
        case good = "Good"
        case great = "Great"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                            Text("Rest Type")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            HStack(spacing: 12) {
                                ForEach(RestType.allCases, id: \.self) { type in
                                    Button(action: {
                                        selectedRestType = type
                                    }) {
                                        HStack {
                                            Text(type.emoji)
                                                .font(.system(size: 20))
                                            Text(type.rawValue)
                                                .font(.system(size: 14, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule()
                                                .fill(selectedRestType == type ? Color.purple : Color.gray.opacity(0.3))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 24)
                        
                        // Hours of Rest
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hours of Rest")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 12) {
                                Text("\(String(format: "%.1f", hours)) hours")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Slider(value: $hours, in: 0...12, step: 0.5)
                                    .tint(.purple)
                                    .padding(.horizontal, 24)
                            }
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 24)
                        
                        // Quality Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quality")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            HStack(spacing: 12) {
                                ForEach(RestQuality.allCases, id: \.self) { qual in
                                    Button(action: {
                                        quality = qual
                                    }) {
                                        Text(qual.rawValue)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(quality == qual ? Color.purple : Color.gray.opacity(0.3))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 120)
                    }
                }
                .background(Color.black)
                
                // Save Button
                VStack {
                    Spacer()
                    Button(action: {
                        stateManager.addTimelineEntry(
                            type: .rest,
                            title: selectedRestType.rawValue,
                            subtitle: "\(String(format: "%.1f", hours))h - \(quality.rawValue)",
                            icon: selectedRestType.emoji
                        )
                        stateManager.navigateTo(.home)
                    }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.purple)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .background(
                        Color.black.opacity(0.95)
                            .ignoresSafeArea()
                    )
                }
            }
        }
    }
}