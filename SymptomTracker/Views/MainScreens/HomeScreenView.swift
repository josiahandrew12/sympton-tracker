//
//  HomeScreenView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var stateManager: AppStateManager

    private var weekDates: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: stateManager.selectedDate) else {
            return []
        }

        var dates: [Date] = []
        var date = weekInterval.start

        for _ in 0..<7 {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }

        return dates
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let name = stateManager.userName.isEmpty ? "there" : stateManager.userName

        switch hour {
        case 5..<12:
            return "Good morning, \(name)!"
        case 12..<17:
            return "Good afternoon, \(name)!"
        case 17..<21:
            return "Good evening, \(name)!"
        default:
            return "Good night, \(name)!"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header with Greeting and Profile
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greeting)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)

                                Text("How are you feeling today?")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white.opacity(0.7))
                            }

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
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(weekDates, id: \.self) { date in
                                    ModernDayCard(
                                        date: date,
                                        isSelected: Calendar.current.isDate(date, inSameDayAs: stateManager.selectedDate)
                                    ) {
                                        stateManager.selectedDate = date
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                            .shadow(
                                color: .white.opacity(0.1),
                                radius: 8,
                                x: 0,
                                y: 2
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
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
                                .foregroundColor(.white)
                            
                            Text("Based on recent patterns")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
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
                                .foregroundColor(.white)
                            
                            Text("Tracked today")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Quick Actions
                    VStack(spacing: 16) {
                        HStack {
                            Text("Quick Actions")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
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
                            
                            ModernActionCard(
                                icon: "bed.double.fill",
                                title: "Rest Tracking",
                                subtitle: "Log your sleep and naps",
                                color: .purple,
                                action: {
                                    stateManager.navigateTo(.restTracking)
                                }
                            )
                            
                            ModernActionCard(
                                icon: "brain.head.profile",
                                title: "Therapy",
                                subtitle: "Track therapy sessions",
                                color: .orange,
                                action: {
                                    stateManager.navigateTo(.therapyTracking)
                                }
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Today's Timeline Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Today's Timeline")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)

                            Spacer()

                            Text(DateFormatter.localizedString(from: stateManager.selectedDate, dateStyle: .medium, timeStyle: .none))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 24)

                        let todaysEntries = stateManager.getTimelineEntriesForDate(stateManager.selectedDate)

                        if todaysEntries.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(.white.opacity(0.3))

                                Text("No entries for this day")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))

                                Text("Start tracking your symptoms, medications, or meals")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white.opacity(0.4))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 32)
                            .padding(.horizontal, 24)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(todaysEntries, id: \.id) { entry in
                                    TimelineEntryCard(entry: entry)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 100) // Extra padding for tab bar
                }
            }
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        }
    }
}