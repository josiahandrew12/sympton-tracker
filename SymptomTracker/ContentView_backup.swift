//
//  ContentView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showOnboarding = true
    @State private var currentStep = 0
    @State private var userName = ""
    @State private var selectedConditions: Set<String> = []
    @State private var selectedSymptoms: Set<String> = []
    @State private var severityLevel = 5.0
    @State private var flareFrequency = "Weekly"
    @State private var selectedTriggers: Set<String> = []
    @State private var selectedRoutines: Set<String> = []
    @State private var selectedGoals: Set<String> = []
    @State private var currentScreen: AppScreen = .home

    var body: some View {
        if showOnboarding {
            OnboardingFlowView(
                currentStep: $currentStep,
                userName: $userName,
                selectedConditions: $selectedConditions,
                selectedSymptoms: $selectedSymptoms,
                severityLevel: $severityLevel,
                flareFrequency: $flareFrequency,
                selectedTriggers: $selectedTriggers,
                selectedRoutines: $selectedRoutines,
                selectedGoals: $selectedGoals,
                showOnboarding: $showOnboarding
            )
        } else {
            switch currentScreen {
            case .home:
                HomeScreenView(currentScreen: $currentScreen)
            case .foodTracking:
                FoodTrackingView(currentScreen: $currentScreen)
            case .medicationTracking:
                MedicationTrackingView(currentScreen: $currentScreen)
            case .restTracking:
                RestTrackingView(currentScreen: $currentScreen)
            case .therapyTracking:
                TherapyTrackingView(currentScreen: $currentScreen)
            case .symptomsTracking:
                SymptomsTrackingView(currentScreen: $currentScreen, selectedSymptoms: $selectedSymptoms, severityLevel: $severityLevel)
            }
        }
    }
}

enum AppScreen {
    case home
    case foodTracking
    case medicationTracking
    case restTracking
    case therapyTracking
    case symptomsTracking
}

// MARK: - Onboarding Flow
struct OnboardingFlowView: View {
    @Binding var currentStep: Int
    @Binding var userName: String
    @Binding var selectedConditions: Set<String>
    @Binding var selectedSymptoms: Set<String>
    @Binding var severityLevel: Double
    @Binding var flareFrequency: String
    @Binding var selectedTriggers: Set<String>
    @Binding var selectedRoutines: Set<String>
    @Binding var selectedGoals: Set<String>
    @Binding var showOnboarding: Bool

    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar
                HStack(spacing: 4) {
                    ForEach(0..<9, id: \.self) { step in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.2))
                            .frame(height: 4)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Content
                TabView(selection: $currentStep) {
                    ModernWelcomeView(currentStep: $currentStep)
                        .tag(0)
                    
                    ModernWhoAreYouView(currentStep: $currentStep, userName: $userName)
                        .tag(1)
                    
                    ModernConditionsView(currentStep: $currentStep, selectedConditions: $selectedConditions)
                        .tag(2)
                    
                    ModernSymptomsView(currentStep: $currentStep, selectedSymptoms: $selectedSymptoms, severityLevel: $severityLevel)
                        .tag(3)
                    
                    ModernFlareFrequencyView(currentStep: $currentStep, flareFrequency: $flareFrequency)
                        .tag(4)
                    
                    ModernTriggersView(currentStep: $currentStep, selectedTriggers: $selectedTriggers)
                        .tag(5)
                    
                    ModernRoutinesView(currentStep: $currentStep, selectedRoutines: $selectedRoutines)
                        .tag(6)
                    
                    ModernGoalsView(currentStep: $currentStep, selectedGoals: $selectedGoals)
                        .tag(7)
                    
                    ModernCompletionView(currentStep: $currentStep, showOnboarding: $showOnboarding)
                        .tag(8)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
            }
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Illustration Section
                VStack(spacing: 0) {
                    // Ground line
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 2)
                        .padding(.horizontal, 40)
                    
                    // Illustration
                    ZStack {
                        // Background elements
                        VStack {
                            Spacer()
                            
                            HStack {
                                // Plant on the left
                                VStack(spacing: 0) {
                                    // Plant pot
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                        .frame(width: 30, height: 20)
                                    
                                    // Plant leaves
                                    VStack(spacing: -5) {
                                        ForEach(0..<3, id: \.self) { _ in
                                            Ellipse()
                                                .fill(Color.green)
                                                .frame(width: 25, height: 15)
                                        }
                                    }
                                }
                                .padding(.leading, 40)
                                
                                Spacer()
                                
                                // Woman character
                                VStack(spacing: 0) {
                                    // Head with hair and headband
                                    ZStack {
                                        // Hair
                                        Ellipse()
                                            .fill(Color.black)
                                            .frame(width: 50, height: 45)
                                        
                                        // Headband
                                        Rectangle()
                                            .fill(Color.purple)
                                            .frame(width: 60, height: 8)
                                            .offset(y: -15)
                                        
                                        // Face
                                        Circle()
                                            .fill(Color.orange.opacity(0.8))
                                            .frame(width: 40, height: 40)
                                        
                                        // Smile
                                        Path { path in
                                            path.addArc(center: CGPoint(x: 0, y: 5), radius: 8, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                                        }
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 16, height: 8)
                                    }
                                    
                                    // Body
                                    VStack(spacing: 0) {
                                        // Top (yellow)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.yellow)
                                            .frame(width: 45, height: 30)
                                        
                                        // Pants (purple)
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.purple)
                                            .frame(width: 40, height: 25)
                                    }
                                    
                                    // Arms and donuts
                                    HStack(spacing: 0) {
                                        // Left arm with tray
                                        VStack {
                                            Rectangle()
                                                .fill(Color.orange.opacity(0.8))
                                                .frame(width: 8, height: 20)
                                            
                                            // Tray with donuts
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.black)
                                                    .frame(width: 35, height: 8)
                                                
                                                HStack(spacing: 2) {
                                                    ForEach(0..<3, id: \.self) { _ in
                                                        Circle()
                                                            .fill(Color.pink)
                                                            .frame(width: 8, height: 8)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        // Right arm with donut
                                        VStack {
                                            Rectangle()
                                                .fill(Color.orange.opacity(0.8))
                                                .frame(width: 8, height: 15)
                                            
                                            Circle()
                                                .fill(Color.pink)
                                                .frame(width: 12, height: 12)
                                        }
                                    }
                                    .offset(y: -10)
                                }
                                
                                Spacer()
                                
                                // Table and lamp on the right
                                VStack(spacing: 0) {
                                    // Lamp
                                    VStack(spacing: 0) {
                                        // Wire
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 1, height: 20)
                                        
                                        // Lamp shade
                                        Ellipse()
                                            .fill(Color.purple)
                                            .frame(width: 25, height: 15)
                                        
                                        // Light
                                        Ellipse()
                                            .fill(Color.yellow.opacity(0.3))
                                            .frame(width: 30, height: 20)
                                    }
                                    
                                    Spacer()
                                    
                                    // Table
                                    VStack(spacing: 0) {
                                        // Table top
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 30, height: 8)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1)
                                            )
                                        
                                        // Table legs
                                        HStack(spacing: 15) {
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 2, height: 20)
                                            
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 2, height: 20)
                                        }
                                    }
                                }
                                .padding(.trailing, 40)
                            }
                            .frame(height: 200)
                        }
                    }
                }
                
                Spacer()
                
                // Welcome Text
                VStack(spacing: 16) {
                    Text("Welcome to")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Text("your personal")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("health tracker")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}

// MARK: - Who Are You View
struct WhoAreYouView: View {
    @Binding var userName: String
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 60) {
                // Header
                VStack(spacing: 20) {
                    Text("Let's get to know you")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Personalizing your health journey starts with your name")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Input Section
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        TextField("Enter your name", text: $userName)
                            .font(.system(size: 22, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(isTextFieldFocused ? Color.blue : Color.black.opacity(0.1), lineWidth: 2)
                                    )
                            )
                            .focused($isTextFieldFocused)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isTextFieldFocused = true
                                }
                            }
                        
                        if !userName.isEmpty {
                            Text("Nice to meet you, \(userName)!")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Add Conditions View
struct AddConditionsView: View {
    @Binding var selectedConditions: Set<String>
    
    let conditions = [
        "Functional neurological disorder", "Autonomic dysfunction", "Chronic Pain", "Fibromyalgia", 
        "Arthritis", "Migraine", "IBS", "Crohn's Disease", "Lupus", "MS"
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 20) {
                    Text("Your conditions")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Help us understand your health profile")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Conditions List
                VStack(spacing: 12) {
                    ForEach(conditions.prefix(4), id: \.self) { condition in
                        ModernConditionCard(
                            condition: condition,
                            isSelected: selectedConditions.contains(condition),
                            onTap: {
                                if selectedConditions.contains(condition) {
                                    selectedConditions.remove(condition)
                                } else {
                                    selectedConditions.insert(condition)
                                }
                            }
                        )
                    }
                    
                    // Add more button
                    Button(action: {
                        // Add new condition functionality
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                            
                            Text("Add another condition")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

// MARK: - Modern Condition Card
struct ModernConditionCard: View {
    let condition: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
                
                Text(condition)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Add Symptoms View
struct AddSymptomsView: View {
    @Binding var selectedSymptoms: Set<String>
    @State private var searchText = ""
    @State private var symptomSeverities: [String: Double] = [:]
    
    let visionSymptoms = ["Blurred vision", "Eye pain", "Dry eyes", "Light sensitivity", "Double vision", "Floaters"]
    let skinSymptoms = ["Rash", "Itching", "Dryness", "Redness", "Swelling"]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 20) {
                    Text("Track your symptoms")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Select symptoms you experience regularly")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Search field
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.secondary)
                    
                    TextField("Search symptoms...", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Vision & Eye Category
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Vision & Eye")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 12) {
                            ForEach(visionSymptoms, id: \.self) { symptom in
                                ModernSymptomCard(
                                    symptom: symptom,
                                    isSelected: selectedSymptoms.contains(symptom),
                                    severity: Binding(
                                        get: { symptomSeverities[symptom] ?? 0 },
                                        set: { symptomSeverities[symptom] = $0 }
                                    ),
                                    onTap: {
                                        if selectedSymptoms.contains(symptom) {
                                            selectedSymptoms.remove(symptom)
                                            symptomSeverities.removeValue(forKey: symptom)
                                        } else {
                                            selectedSymptoms.insert(symptom)
                                            if symptomSeverities[symptom] == nil {
                                                symptomSeverities[symptom] = 5
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    // Skin & Dermatological Category
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Skin & Dermatological")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 12) {
                            ForEach(skinSymptoms, id: \.self) { symptom in
                                ModernSymptomCard(
                                    symptom: symptom,
                                    isSelected: selectedSymptoms.contains(symptom),
                                    severity: Binding(
                                        get: { symptomSeverities[symptom] ?? 0 },
                                        set: { symptomSeverities[symptom] = $0 }
                                    ),
                                    onTap: {
                                        if selectedSymptoms.contains(symptom) {
                                            selectedSymptoms.remove(symptom)
                                            symptomSeverities.removeValue(forKey: symptom)
                                        } else {
                                            selectedSymptoms.insert(symptom)
                                            if symptomSeverities[symptom] == nil {
                                                symptomSeverities[symptom] = 5
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Modern Symptom Card
struct ModernSymptomCard: View {
    let symptom: String
    let isSelected: Bool
    @Binding var severity: Double
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    // Selection indicator
                    ZStack {
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text(symptom)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.black.opacity(0.05) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Severity slider (only show when selected)
            if isSelected {
                VStack(spacing: 8) {
                    HStack {
                        Text("Severity")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(severity))/10")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    Slider(value: $severity, in: 0...10, step: 1)
                        .accentColor(.black)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.03))
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

// MARK: - Flare Frequency View
struct FlareFrequencyView: View {
    @Binding var flareFrequency: String
    
    let frequencies = ["Constant", "Intermittent", "Occasionally", "Sporadic"]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 20) {
                    Text("Flare frequency")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("How often do your symptoms flare up?")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Frequency Options
                VStack(spacing: 12) {
                    ForEach(frequencies, id: \.self) { frequency in
                        ModernFrequencyCard(
                            frequency: frequency,
                            isSelected: flareFrequency == frequency,
                            onTap: {
                                flareFrequency = frequency
                            }
                        )
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

// MARK: - Modern Frequency Card
struct ModernFrequencyCard: View {
    let frequency: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
                
                Text(frequency)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Triggers View
struct TriggersView: View {
    @Binding var selectedTriggers: Set<String>
    @State private var searchText = ""
    
    let dietTriggers = ["Caffeine", "Sugar", "Dairy", "Gluten"]
    let environmentTriggers = ["Work", "Travel", "Exercise", "School"]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 20) {
                    Text("Track your triggers")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Identify what affects your symptoms")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Search field
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.secondary)
                    
                    TextField("Search triggers...", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Diet Category
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Diet")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 12) {
                            ForEach(dietTriggers, id: \.self) { trigger in
                                ModernTriggerCard(
                                    trigger: trigger,
                                    isSelected: selectedTriggers.contains(trigger),
                                    onTap: {
                                        if selectedTriggers.contains(trigger) {
                                            selectedTriggers.remove(trigger)
                                        } else {
                                            selectedTriggers.insert(trigger)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    // Environment Category
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Environment")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 12) {
                            ForEach(environmentTriggers, id: \.self) { trigger in
                                ModernTriggerCard(
                                    trigger: trigger,
                                    isSelected: selectedTriggers.contains(trigger),
                                    onTap: {
                                        if selectedTriggers.contains(trigger) {
                                            selectedTriggers.remove(trigger)
                                        } else {
                                            selectedTriggers.insert(trigger)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Modern Trigger Card
struct ModernTriggerCard: View {
    let trigger: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(trigger)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Goals View
struct GoalsView: View {
    @Binding var selectedGoals: Set<String>
    @Binding var showOnboarding: Bool
    
    let goals = [
        ("Reduce symptom severity", "chart.line.uptrend.xyaxis"),
        ("Track treatments", "pills.fill"),
        ("Share data with doctors", "person.crop.circle.badge.checkmark"),
        ("Discover flare triggers", "magnifyingglass")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 20) {
                    Text("Your goals")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("What matters most to you?")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Goals List
                VStack(spacing: 12) {
                    ForEach(goals, id: \.0) { goal in
                        ModernGoalCard(
                            goal: goal.0,
                            icon: goal.1,
                            isSelected: selectedGoals.contains(goal.0),
                            onTap: {
                                if selectedGoals.contains(goal.0) {
                                    selectedGoals.remove(goal.0)
                                } else {
                                    selectedGoals.insert(goal.0)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Complete setup button
            Button("Complete Setup") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOnboarding = false
                }
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(Color.black)
            .cornerRadius(12)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Modern Goal Card
struct ModernGoalCard: View {
    let goal: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                
                Text(goal)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Daily Routines View
struct DailyRoutinesView: View {
    @Binding var selectedRoutines: Set<String>
    
    let routines = [
        ("Sleep", "moon.fill"),
        ("Exercise", "dumbbell.fill"),
        ("Meals", "apple.logo"),
        ("Stress", "bolt.fill")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 50) {
                // Header
                VStack(spacing: 20) {
                    Text("Daily routines")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Track your daily habits and activities")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Routines List
                VStack(spacing: 12) {
                    ForEach(routines, id: \.0) { routine in
                        ModernRoutineCard(
                            routine: routine.0,
                            icon: routine.1,
                            isSelected: selectedRoutines.contains(routine.0),
                            onTap: {
                                if selectedRoutines.contains(routine.0) {
                                    selectedRoutines.remove(routine.0)
                                } else {
                                    selectedRoutines.insert(routine.0)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

// MARK: - Modern Routine Card
struct ModernRoutineCard: View {
    let routine: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                
                Text(routine)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.black.opacity(0.05) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 48) {
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.05))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .thin))
                        .foregroundColor(.black)
                }
                
                // Content
                VStack(spacing: 16) {
                    Text("You're all set!")
                        .font(.system(size: 32, weight: .thin))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Your personalized health tracking journey begins now")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            // Let's go button
            Button("Let's go!") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOnboarding = false
                }
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(Color.black)
            .cornerRadius(12)
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Home Screen View
struct HomeScreenView: View {
    @Binding var currentScreen: AppScreen
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
                                Text("J")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60) // Increased top padding to avoid status bar
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
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Flare Risk")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Sleep pattern")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                        
                        // Insights Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.15))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "brain.head.profile")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.blue)
                                    )
                                
                                Spacer()
                                
                                Text("INSIGHT")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.blue.opacity(0.1))
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Pattern Found")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Fatigue +90min")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    
                    // Quick Actions Horizontal
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Quick Actions")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                Button(action: {
                                    currentScreen = .medicationTracking
                                }) {
                                    ModernActionCard(
                                        icon: "pills.fill",
                                        title: "Medications",
                                        subtitle: "Track your meds",
                                        color: .blue
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    currentScreen = .symptomsTracking
                                }) {
                                    ModernActionCard(
                                        icon: "heart.fill",
                                        title: "Symptoms",
                                        subtitle: "Log symptoms",
                                        color: .red
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    currentScreen = .foodTracking
                                }) {
                                    ModernActionCard(
                                        icon: "fork.knife",
                                        title: "Meals",
                                        subtitle: "Food diary",
                                        color: .orange
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    currentScreen = .restTracking
                                }) {
                                    ModernActionCard(
                                        icon: "bed.double.fill",
                                        title: "Rest",
                                        subtitle: "Sleep quality",
                                        color: .purple
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    currentScreen = .therapyTracking
                                }) {
                                    ModernActionCard(
                                        icon: "brain.head.profile",
                                        title: "Therapy",
                                        subtitle: "Mental health",
                                        color: .green
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Today's Reminders
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Today's Reminders")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                            Spacer()
                            
                            Button("View All") {
                                // Action
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            ModernReminderCard(
                                title: "Morning Medications",
                                time: "8:00 AM",
                                isCompleted: false,
                                icon: "pills.fill"
                            )
                            
                            ModernReminderCard(
                                title: "Lunch Check-in",
                                time: "12:00 PM",
                                isCompleted: true,
                                icon: "heart.fill"
                            )
                            
                            ModernReminderCard(
                                title: "Evening Medications",
                                time: "8:00 PM",
                                isCompleted: false,
                                icon: "pills.fill"
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
    }
}

// MARK: - Modern Day Card
struct ModernDayCard: View {
    let day: Int
    let isSelected: Bool
    
    private let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let dayNumbers = ["15", "16", "17", "18", "19", "20", "21"]
    
    var body: some View {
        VStack(spacing: 10) {
            Text(dayNames[day])
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(dayNumbers[day])
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                )
        }
        .frame(width: 56)
        .padding(.vertical, 8)
    }
}

// MARK: - Food Tracking View
struct FoodTrackingView: View {
    @Binding var currentScreen: AppScreen
    @State private var searchText = ""
    @State private var selectedMealType = "Breakfast"
    @State private var selectedFoods: [FoodItem] = []
    @State private var showingAddFood = false
    
    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"]
    private let recentFoods = [
        FoodItem(name: "Apple, medium", calories: 95, icon: "🍎", color: .red),
        FoodItem(name: "Caesar Salad", calories: 320, icon: "🥗", color: .green),
        FoodItem(name: "Whole wheat bread", calories: 80, icon: "🍞", color: .yellow),
        FoodItem(name: "Banana, large", calories: 121, icon: "🍌", color: .purple),
        FoodItem(name: "Milk, 2% fat", calories: 122, icon: "🥛", color: .blue)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Track Food")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Profile action
                        }) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Search foods...", text: $searchText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Meal Type Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(mealTypes, id: \.self) { mealType in
                                Button(action: {
                                    selectedMealType = mealType
                                }) {
                                    Text(mealType)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(selectedMealType == mealType ? .white : .black)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedMealType == mealType ? Color.orange : Color.gray.opacity(0.1))
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Quick Add Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Add")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 12) {
                            QuickAddButton(
                                title: "Calories",
                                icon: "flame.fill",
                                color: .orange,
                                isSelected: true
                            )
                            
                            QuickAddButton(
                                title: "Recipe",
                                icon: "book.fill",
                                color: .blue,
                                isSelected: false
                            )
                            
                            QuickAddButton(
                                title: "Barcode",
                                icon: "barcode",
                                color: .green,
                                isSelected: false
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                    
                    // Recent Foods Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(recentFoods, id: \.name) { food in
                                FoodItemRow(food: food) {
                                    selectedFoods.append(food)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                    
                    // Popular Foods Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Popular")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(recentFoods, id: \.name) { food in
                                FoodItemRow(food: food) {
                                    selectedFoods.append(food)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
}

// MARK: - Food Item Model
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let icon: String
    let color: Color
}

// MARK: - Quick Add Button
struct QuickAddButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Button(action: {
            // Quick add action
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color : Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Food Item Row
struct FoodItemRow: View {
    let food: FoodItem
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Food Icon
            ZStack {
                Circle()
                    .fill(food.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(food.icon)
                    .font(.system(size: 24))
            }
            
            // Food Info
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text("\(food.calories) calories")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Add Button
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Medication Tracking View
struct MedicationTrackingView: View {
    @Binding var currentScreen: AppScreen
    @State private var searchText = ""
    @State private var selectedMedications: [MedicationItem] = []
    @State private var showingAddMedication = false
    
    private let commonMedications = [
        MedicationItem(name: "Ibuprofen", dosage: "200mg", frequency: "As needed", icon: "💊", color: .red),
        MedicationItem(name: "Vitamin D", dosage: "1000 IU", frequency: "Daily", icon: "💊", color: .yellow),
        MedicationItem(name: "Omega-3", dosage: "1000mg", frequency: "Daily", icon: "💊", color: .blue),
        MedicationItem(name: "Magnesium", dosage: "400mg", frequency: "Evening", icon: "💊", color: .green),
        MedicationItem(name: "Probiotics", dosage: "50 billion CFU", frequency: "Daily", icon: "💊", color: .purple)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Track Medications")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddMedication = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Search medications...", text: $searchText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Today's Medications
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Medications")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        if selectedMedications.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "pills.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("No medications logged today")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("Add your medications to track them")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(selectedMedications, id: \.id) { medication in
                                    MedicationItemRow(medication: medication) {
                                        if let index = selectedMedications.firstIndex(where: { $0.id == medication.id }) {
                                            selectedMedications[index].isTaken.toggle()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Common Medications
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Common Medications")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(commonMedications, id: \.name) { medication in
                                Button(action: {
                                    var newMedication = medication
                                    newMedication.isTaken = false
                                    selectedMedications.append(newMedication)
                                }) {
                                    MedicationAddRow(medication: medication)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .sheet(isPresented: $showingAddMedication) {
            AddMedicationView(medications: $selectedMedications)
        }
    }
}

// MARK: - Medication Item Model
struct MedicationItem: Identifiable {
    let id = UUID()
    let name: String
    let dosage: String
    let frequency: String
    let icon: String
    let color: Color
    var isTaken: Bool = false
}

// MARK: - Medication Item Row
struct MedicationItemRow: View {
    let medication: MedicationItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Medication Icon
            ZStack {
                Circle()
                    .fill(medication.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(medication.icon)
                    .font(.system(size: 24))
            }
            
            // Medication Info
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text("\(medication.dosage) • \(medication.frequency)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Taken Button
            Button(action: onToggle) {
                Image(systemName: medication.isTaken ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(medication.isTaken ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Medication Add Row
struct MedicationAddRow: View {
    let medication: MedicationItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Medication Icon
            ZStack {
                Circle()
                    .fill(medication.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(medication.icon)
                    .font(.system(size: 24))
            }
            
            // Medication Info
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text("\(medication.dosage) • \(medication.frequency)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Add Button
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Color.blue)
                .clipShape(Circle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Add Medication View
struct AddMedicationView: View {
    @Binding var medications: [MedicationItem]
    @Environment(\.presentationMode) var presentationMode
    @State private var medicationName = ""
    @State private var dosage = ""
    @State private var frequency = "Daily"
    
    private let frequencies = ["Daily", "Twice daily", "As needed", "Weekly", "Monthly"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Medication Name")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("Enter medication name", text: $medicationName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dosage")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("e.g., 200mg, 1 tablet", text: $dosage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Frequency")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(frequencies, id: \.self) { freq in
                            Text(freq).tag(freq)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                
                Spacer()
                
                Button(action: {
                    let newMedication = MedicationItem(
                        name: medicationName,
                        dosage: dosage,
                        frequency: frequency,
                        icon: "💊",
                        color: .blue
                    )
                    medications.append(newMedication)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Medication")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .disabled(medicationName.isEmpty || dosage.isEmpty)
            }
            .padding(24)
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Rest Tracking View
struct RestTrackingView: View {
    @Binding var currentScreen: AppScreen
    @State private var sleepHours = 8.0
    @State private var sleepQuality = 3
    @State private var bedTime = Date()
    @State private var wakeTime = Date()
    @State private var sleepNotes = ""
    @State private var showingSleepLog = false
    
    private let qualityOptions = [
        (1, "Poor", Color.red),
        (2, "Fair", Color.orange),
        (3, "Good", Color.yellow),
        (4, "Very Good", Color.green),
        (5, "Excellent", Color.blue)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Track Rest")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            showingSleepLog = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Sleep Summary Card
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Last Night's Sleep")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("\(String(format: "%.1f", sleepHours)) hours")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Quality")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text(qualityOptions[sleepQuality - 1].1)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(qualityOptions[sleepQuality - 1].2)
                            }
                        }
                        
                        // Sleep Quality Slider
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sleep Quality")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack {
                                ForEach(qualityOptions, id: \.0) { option in
                                    Button(action: {
                                        sleepQuality = option.0
                                    }) {
                                        Circle()
                                            .fill(sleepQuality == option.0 ? option.2 : Color.gray.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text("\(option.0)")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(sleepQuality == option.0 ? .white : .gray)
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Sleep Duration
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sleep Duration")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Hours of Sleep")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(String(format: "%.1f", sleepHours)) hours")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.purple)
                            }
                            
                            Slider(value: $sleepHours, in: 0...12, step: 0.5)
                                .accentColor(.purple)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Sleep Times
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sleep Schedule")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Bedtime")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    DatePicker("", selection: $bedTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text("Wake Time")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    DatePicker("", selection: $wakeTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Sleep Tips
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sleep Tips")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            SleepTipRow(icon: "moon.fill", tip: "Keep a consistent sleep schedule")
                            SleepTipRow(icon: "thermometer", tip: "Keep your room cool (65-68°F)")
                            SleepTipRow(icon: "phone.fill", tip: "Avoid screens 1 hour before bed")
                            SleepTipRow(icon: "cup.and.saucer.fill", tip: "Limit caffeine after 2 PM")
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .sheet(isPresented: $showingSleepLog) {
            SleepLogView()
        }
    }
}

// MARK: - Sleep Tip Row
struct SleepTipRow: View {
    let icon: String
    let tip: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.purple)
                .frame(width: 20)
            
            Text(tip)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

// MARK: - Sleep Log View
struct SleepLogView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var sleepNotes = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sleep Notes")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("How did you sleep? Any dreams or disturbances?", text: $sleepNotes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(5...10)
                }
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Sleep Log")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.purple)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .navigationTitle("Sleep Log")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Therapy Tracking View
struct TherapyTrackingView: View {
    @Binding var currentScreen: AppScreen
    @State private var moodRating = 3
    @State private var stressLevel = 3
    @State private var therapyNotes = ""
    @State private var showingTherapySession = false
    @State private var selectedActivities: Set<String> = []
    
    private let moodOptions = [
        (1, "😢", "Very Low", Color.red),
        (2, "😔", "Low", Color.orange),
        (3, "😐", "Neutral", Color.yellow),
        (4, "😊", "Good", Color.green),
        (5, "😄", "Excellent", Color.blue)
    ]
    
    private let stressOptions = [
        (1, "Very Low", Color.green),
        (2, "Low", Color.yellow),
        (3, "Moderate", Color.orange),
        (4, "High", Color.red),
        (5, "Very High", Color.purple)
    ]
    
    private let therapyActivities = [
        "Meditation", "Deep Breathing", "Journaling", "Exercise", 
        "Reading", "Music", "Nature Walk", "Art Therapy"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Track Therapy")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            showingTherapySession = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Mood & Stress Summary
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Current Mood")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    Text(moodOptions[moodRating - 1].1)
                                        .font(.system(size: 32))
                                    
                                    Text(moodOptions[moodRating - 1].2)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(moodOptions[moodRating - 1].3)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("Stress Level")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text(stressOptions[stressLevel - 1].1)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(stressOptions[stressLevel - 1].2)
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Mood Rating
                    VStack(alignment: .leading, spacing: 16) {
                        Text("How are you feeling?")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 12) {
                            ForEach(moodOptions, id: \.0) { option in
                                Button(action: {
                                    moodRating = option.0
                                }) {
                                    VStack(spacing: 8) {
                                        Text(option.1)
                                            .font(.system(size: 32))
                                        
                                        Circle()
                                            .fill(moodRating == option.0 ? option.3 : Color.gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Stress Level
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stress Level")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Current Stress")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text(stressOptions[stressLevel - 1].1)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(stressOptions[stressLevel - 1].2)
                            }
                            
                            HStack {
                                ForEach(stressOptions, id: \.0) { option in
                                    Button(action: {
                                        stressLevel = option.0
                                    }) {
                                        Circle()
                                            .fill(stressLevel == option.0 ? option.2 : Color.gray.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text("\(option.0)")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(stressLevel == option.0 ? .white : .gray)
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Therapy Activities
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Therapy Activities")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(therapyActivities, id: \.self) { activity in
                                Button(action: {
                                    if selectedActivities.contains(activity) {
                                        selectedActivities.remove(activity)
                                    } else {
                                        selectedActivities.insert(activity)
                                    }
                                }) {
                                    HStack {
                                        Text(activity)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(selectedActivities.contains(activity) ? .white : .black)
                                        
                                        Spacer()
                                        
                                        if selectedActivities.contains(activity) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedActivities.contains(activity) ? Color.green : Color.gray.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Mental Health Tips
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Mental Health Tips")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            TherapyTipRow(icon: "heart.fill", tip: "Practice gratitude daily")
                            TherapyTipRow(icon: "leaf.fill", tip: "Spend time in nature")
                            TherapyTipRow(icon: "person.2.fill", tip: "Connect with loved ones")
                            TherapyTipRow(icon: "book.fill", tip: "Read something inspiring")
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .sheet(isPresented: $showingTherapySession) {
            TherapySessionView()
        }
    }
}

// MARK: - Therapy Tip Row
struct TherapyTipRow: View {
    let icon: String
    let tip: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.green)
                .frame(width: 20)
            
            Text(tip)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

// MARK: - Therapy Session View
struct TherapySessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var sessionNotes = ""
    @State private var sessionType = "Individual"
    
    private let sessionTypes = ["Individual", "Group", "Family", "Couples"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Session Type")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Picker("Session Type", selection: $sessionType) {
                        ForEach(sessionTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Session Notes")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("How did the session go? What did you discuss?", text: $sessionNotes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(5...10)
                }
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Session")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .navigationTitle("Therapy Session")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Symptoms Tracking View
struct SymptomsTrackingView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedSymptoms: Set<String>
    @Binding var severityLevel: Double
    @State private var currentSymptomSeverities: [String: Double] = [:]
    @State private var showingAddSymptom = false
    
    // Dummy data based on common symptoms from onboarding
    private let commonSymptoms = [
        "Fatigue", "Pain", "Brain Fog", "Sleep Issues", "Mood Changes", 
        "Digestive Issues", "Headaches", "Joint Stiffness", "Nausea", "Dizziness"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Track Symptoms")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddSymptom = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Today's Symptoms Summary
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Today's Symptoms")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("\(selectedSymptoms.count) logged")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Average Severity")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("\(String(format: "%.1f", averageSeverity))")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Current Symptoms
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Current Symptoms")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        if selectedSymptoms.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("No symptoms logged today")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("Add symptoms to track their severity")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(Array(selectedSymptoms), id: \.self) { symptom in
                                    SymptomTrackingRow(
                                        symptom: symptom,
                                        severity: Binding(
                                            get: { currentSymptomSeverities[symptom] ?? 5.0 },
                                            set: { currentSymptomSeverities[symptom] = $0 }
                                        ),
                                        onRemove: {
                                            selectedSymptoms.remove(symptom)
                                            currentSymptomSeverities.removeValue(forKey: symptom)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Common Symptoms
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Common Symptoms")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(commonSymptoms, id: \.self) { symptom in
                                if !selectedSymptoms.contains(symptom) {
                                    Button(action: {
                                        selectedSymptoms.insert(symptom)
                                        currentSymptomSeverities[symptom] = 5.0
                                    }) {
                                        SymptomAddCard(symptom: symptom)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .sheet(isPresented: $showingAddSymptom) {
            AddSymptomView(symptoms: $selectedSymptoms, severities: $currentSymptomSeverities)
        }
    }
    
    private var averageSeverity: Double {
        let severities = currentSymptomSeverities.values
        return severities.isEmpty ? 0.0 : severities.reduce(0, +) / Double(severities.count)
    }
}

// MARK: - Symptom Tracking Row
struct SymptomTrackingRow: View {
    let symptom: String
    @Binding var severity: Double
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Symptom Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }
                
                // Symptom Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(symptom)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text("Severity: \(String(format: "%.1f", severity))/10")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Remove Button
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Severity Slider
            VStack(spacing: 8) {
                HStack {
                    Text("Mild")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text("Severe")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
                
                Slider(value: $severity, in: 1...10, step: 0.5)
                    .accentColor(.red)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}

// MARK: - Symptom Add Card
struct SymptomAddCard: View {
    let symptom: String
    
    var body: some View {
        HStack {
            Text(symptom)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.red)
                .clipShape(Circle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Add Symptom View
struct AddSymptomView: View {
    @Binding var symptoms: Set<String>
    @Binding var severities: [String: Double]
    @Environment(\.presentationMode) var presentationMode
    @State private var symptomName = ""
    @State private var initialSeverity = 5.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Symptom Name")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("Enter symptom name", text: $symptomName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Initial Severity")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Mild")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", initialSeverity))/10")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Text("Severe")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.red)
                        }
                        
                        Slider(value: $initialSeverity, in: 1...10, step: 0.5)
                            .accentColor(.red)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    symptoms.insert(symptomName)
                    severities[symptomName] = initialSeverity
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Symptom")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .disabled(symptomName.isEmpty)
            }
            .padding(24)
            .navigationTitle("Add Symptom")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Modern Action Card
struct ModernActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.2), color.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
        .frame(width: 100, height: 120)
        .padding(16)
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
    }
}

// MARK: - Modern Reminder Card
struct ModernReminderCard: View {
    let title: String
    let time: String
    let isCompleted: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Status indicator
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.green : Color(.systemGray5))
                    .frame(width: 12, height: 12)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(time)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(20)
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
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let dayMonth: DateFormatter = {
    let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
    return formatter
}()
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}