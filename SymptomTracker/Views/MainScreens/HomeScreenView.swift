//
//  HomeScreenView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var selectedDate = Date()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header with Profile
                    HStack {
                        Spacer()
                        
                        // Profile Avatar
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(stateManager.userName.isEmpty ? "U" : String(stateManager.userName.prefix(1)))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Calendar Section in Box
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.blue)
                            
                            Text("This Week")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<7) { day in
                                    ModernDayCard(
                                        day: day,
                                        isSelected: day == 2
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(
                                color: Color.black.opacity(0.05),
                                radius: 8,
                                x: 0,
                                y: 2
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Health Status Cards
                    HStack(spacing: 12) {
                        // Flare Risk Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.15))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "waveform.path.ecg")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.orange)
                                    )
                                
                                Spacer()
                                
                                Text("MEDIUM")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.orange.opacity(0.1))
                                    )
                            }
                            
                            Text("Flare Risk")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Based on recent patterns")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        
                        // Symptoms Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Circle()
                                    .fill(Color.red.opacity(0.15))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "bandage.fill")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                    )
                                
                                Spacer()
                                
                                Text("3")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            
                            Text("Active Symptoms")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Tracked today")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Quick Actions
                    VStack(spacing: 16) {
                        HStack {
                            Text("Quick Actions")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            ModernActionCard(
                                icon: "plus.circle.fill",
                                title: "Log Symptoms",
                                subtitle: "Record how you're feeling",
                                color: .red,
                                action: {
                                    stateManager.navigateTo(.symptomsTracking)
                                }
                            )
                            
                            ModernActionCard(
                                icon: "pills.fill",
                                title: "Medications",
                                subtitle: "Track your medications",
                                color: .blue,
                                action: {
                                    stateManager.navigateTo(.medicationTracking)
                                }
                            )
                            
                            ModernActionCard(
                                icon: "fork.knife",
                                title: "Food Tracking",
                                subtitle: "Monitor your nutrition",
                                color: .green,
                                action: {
                                    stateManager.navigateTo(.foodTracking)
                                }
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Reminders Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Reminders")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            ModernReminderCard(
                                icon: "pills.fill",
                                title: "Morning Medication",
                                time: "8:00 AM",
                                isCompleted: false
                            )
                            
                            ModernReminderCard(
                                icon: "bed.double.fill",
                                title: "Bedtime Routine",
                                time: "10:00 PM",
                                isCompleted: true
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100) // Extra padding for tab bar
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}