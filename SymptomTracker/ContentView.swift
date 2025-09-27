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
                SymptomsTrackingView(currentScreen: $currentScreen)
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
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea()
                
        VStack(spacing: 0) {
                    // Progress indicator
                    VStack(spacing: 16) {
                HStack(spacing: 8) {
                            ForEach(0..<9, id: \.self) { step in
                        Circle()
                                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 10, height: 10)
                            .scaleEffect(step == currentStep ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                            }
                        }
                        
                        Text("Step \(currentStep + 1) of 9")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 20)
            
            // Current step content
            ScrollView {
                VStack(spacing: 0) {
                    switch currentStep {
                    case 0:
                                NewWelcomeView()
                    case 1:
                                NewProfileSetupView(userName: $userName)
                    case 2:
                                NewConditionsView(selectedConditions: $selectedConditions)
                    case 3:
                                NewSymptomsView(selectedSymptoms: $selectedSymptoms, severityLevel: $severityLevel)
                    case 4:
                                FlarePatternView(flareFrequency: $flareFrequency)
                    case 5:
                                TreatmentsView()
                    case 6:
                                TriggersView(selectedTriggers: $selectedTriggers, selectedRoutines: $selectedRoutines)
                    case 7:
                        GoalsView(selectedGoals: $selectedGoals, showOnboarding: $showOnboarding)
                    case 8:
                                OnboardingSummaryView(
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
                    default:
                                NewWelcomeView()
                    }
                }
            }
            
            // Navigation buttons
                    HStack(spacing: 16) {
                if currentStep > 0 {
                    Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep -= 1
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
                                if currentStep < 8 {
                            currentStep += 1
                                } else {
                                    // Complete onboarding
                                    showOnboarding = false
                                }
                        }
                    }) {
                            HStack(spacing: 8) {
                                if currentStep == 8 {
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

// MARK: - New Welcome View
struct NewWelcomeView: View {
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

// MARK: - Feature Preview Row
struct FeaturePreviewRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
        ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
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

// MARK: - New Profile Setup View
struct NewProfileSetupView: View {
    @Binding var userName: String
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
            TextField("Enter your name", text: $userName)
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

// MARK: - Benefit Row
struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
                                            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

// MARK: - New Conditions View
struct NewConditionsView: View {
    @Binding var selectedConditions: Set<String>
    
    let conditions = [
        ("Functional neurological disorder", "brain.head.profile"),
        ("Autonomic dysfunction", "heart.fill"),
        ("Chronic Pain", "bandage.fill"),
        ("Fibromyalgia", "figure.walk"),
        ("Arthritis", "figure.arms.open"),
        ("Migraine", "bolt.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Your Chronic Illness")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Select any conditions you're managing")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Conditions grid
            VStack(spacing: 12) {
                ForEach(conditions, id: \.0) { condition in
                    ConditionCard(
                        condition: condition.0,
                        icon: condition.1,
                        isSelected: selectedConditions.contains(condition.0),
                        onTap: {
                            if selectedConditions.contains(condition.0) {
                                selectedConditions.remove(condition.0)
                            } else {
                                selectedConditions.insert(condition.0)
                            }
                        }
                    )
                }
                
                // Add custom condition
                Button(action: {
                    // Add custom condition functionality
                }) {
                    HStack(spacing: 16) {
                    ZStack {
                                                        Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add another condition")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Tap to add a custom condition")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        
                            Spacer()
                            
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
                                        
                                        Spacer()
        }
    }
}

// MARK: - Condition Card
struct ConditionCard: View {
    let condition: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
        ZStack {
                                            Circle()
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(condition)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text("Health condition")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - New Symptoms View
struct NewSymptomsView: View {
    @Binding var selectedSymptoms: Set<String>
    @Binding var severityLevel: Double
    @State private var symptomSeverities: [String: Double] = [:]
    
    let symptoms = [
        ("Fatigue", "zzz", Color.orange),
        ("Pain", "bandage.fill", Color.red),
        ("Brain Fog", "brain.head.profile", Color.purple),
        ("Nausea", "stomach.fill", Color.green),
        ("Headache", "bolt.fill", Color.yellow),
        ("Dizziness", "arrow.triangle.2.circlepath", Color.blue),
        ("Anxiety", "heart.fill", Color.pink),
        ("Sleep Issues", "moon.fill", Color.indigo)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Track Your Symptoms")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Select symptoms you experience regularly")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Symptoms with individual scales
            VStack(spacing: 16) {
                ForEach(symptoms, id: \.0) { symptom in
                    SymptomCardWithScale(
                        symptom: symptom.0,
                        icon: symptom.1,
                        color: symptom.2,
                        isSelected: selectedSymptoms.contains(symptom.0),
                        severity: symptomSeverities[symptom.0] ?? 5.0,
                        onTap: {
                            if selectedSymptoms.contains(symptom.0) {
                                selectedSymptoms.remove(symptom.0)
                                symptomSeverities.removeValue(forKey: symptom.0)
                            } else {
                                selectedSymptoms.insert(symptom.0)
                                symptomSeverities[symptom.0] = 5.0
                            }
                        },
                        onSeverityChange: { newValue in
                            symptomSeverities[symptom.0] = newValue
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Symptom Card
struct SymptomCard: View {
    let symptom: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                    ZStack {
                    Circle()
                        .fill(isSelected ? color.opacity(0.2) : color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? color : color.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(symptom)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Symptom")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                            Spacer()
                            
                ZStack {
                                        Circle()
                        .stroke(isSelected ? color : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Symptom Card With Scale
struct SymptomCardWithScale: View {
    let symptom: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let severity: Double
    let onTap: () -> Void
    let onSeverityChange: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Main symptom card
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? color.opacity(0.2) : color.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(isSelected ? color : color.opacity(0.7))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(symptom)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Symptom")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(isSelected ? color : Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(color)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Individual severity scale (only show if selected)
            if isSelected {
                VStack(spacing: 8) {
                            HStack {
                        Text("Severity")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(Int(severity))/10")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(color)
                    }
                    
                    Slider(value: Binding(
                        get: { severity },
                        set: { onSeverityChange($0) }
                    ), in: 1...10, step: 1)
                        .accentColor(color)
                    
                    HStack {
                        Text("Mild")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Severe")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(color.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
    }
}

// MARK: - Flare Pattern View
struct FlarePatternView: View {
    @Binding var flareFrequency: String
    
    let patterns = [
        ("Episodic", "waveform.path.ecg", "Symptoms flare up periodically"),
        ("Constant", "line.horizontal.3", "Symptoms are always present"),
        ("Variable", "arrow.up.arrow.down", "Symptoms change unpredictably")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Flare Patterns")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("How do your symptoms typically behave?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Pattern options
            VStack(spacing: 12) {
                ForEach(patterns, id: \.0) { pattern in
                    FlarePatternCard(
                        title: pattern.0,
                        icon: pattern.1,
                        description: pattern.2,
                        isSelected: flareFrequency == pattern.0,
                        onTap: {
                            flareFrequency = pattern.0
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
                                
                                Spacer()
        }
    }
}

// MARK: - Flare Pattern Card
struct FlarePatternCard: View {
    let title: String
    let icon: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                                    ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                ZStack {
                                        Circle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Treatments View
struct TreatmentsView: View {
    @State private var selectedTreatments: Set<String> = []
    
    let treatments = [
        ("Medications", "pills.fill"),
        ("Supplements", "leaf.fill"),
        ("Diet Restrictions", "fork.knife"),
        ("Physical Therapy", "figure.walk"),
        ("Mental Health Therapy", "brain.head.profile"),
        ("Alternative Medicine", "leaf.circle.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Current Treatments")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("What treatments or supports are you currently using?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Treatment options
            VStack(spacing: 12) {
                ForEach(treatments, id: \.0) { treatment in
                    TreatmentCard(
                        treatment: treatment.0,
                        icon: treatment.1,
                        isSelected: selectedTreatments.contains(treatment.0),
                        onTap: {
                            if selectedTreatments.contains(treatment.0) {
                                selectedTreatments.remove(treatment.0)
                            } else {
                                selectedTreatments.insert(treatment.0)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
                                        
                                        Spacer()
        }
    }
}

// MARK: - Treatment Card
struct TreatmentCard: View {
    let treatment: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                                            ZStack {
                                            Circle()
                        .fill(isSelected ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .green : .gray)
                }
                
                Text(treatment)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                ZStack {
                                                        Circle()
                        .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Triggers View
struct TriggersView: View {
    @Binding var selectedTriggers: Set<String>
    @Binding var selectedRoutines: Set<String>
    
    let triggers = [
        ("Diet", "fork.knife", Color.orange),
        ("Stress", "exclamationmark.triangle.fill", Color.red),
        ("Sleep", "moon.fill", Color.indigo),
        ("Movement", "figure.walk", Color.blue),
        ("Hormones", "waveform.path.ecg", Color.pink),
        ("Environment", "cloud.sun.fill", Color.yellow)
    ]
    
    let routines = [
        ("Sleep", "moon.fill"),
        ("Exercise", "figure.walk"),
        ("Meals", "fork.knife"),
        ("Stress", "exclamationmark.triangle.fill"),
        ("All of the above", "checkmark.circle.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Triggers & Routines")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("What would you like to track for insights?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Triggers section
            VStack(alignment: .leading, spacing: 16) {
                Text("Triggers to Track")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 12) {
                    ForEach(triggers, id: \.0) { trigger in
                        TriggerCardFullWidth(
                            trigger: trigger.0,
                            icon: trigger.1,
                            color: trigger.2,
                            isSelected: selectedTriggers.contains(trigger.0),
                            onTap: {
                                if selectedTriggers.contains(trigger.0) {
                                    selectedTriggers.remove(trigger.0)
                                } else {
                                    selectedTriggers.insert(trigger.0)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            // Routines section
            VStack(alignment: .leading, spacing: 16) {
                Text("Things You Want to Track")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 12) {
                    ForEach(routines, id: \.0) { routine in
                        RoutineCard(
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
            }
            .padding(.horizontal, 24)
                                        
                                        Spacer()
        }
    }
}

// MARK: - Trigger Card
struct TriggerCard: View {
    let trigger: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                                            Circle()
                        .fill(isSelected ? color.opacity(0.2) : color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? color : color.opacity(0.7))
                }
                
                Text(trigger)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                            .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Trigger Card Full Width
struct TriggerCardFullWidth: View {
    let trigger: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color.opacity(0.2) : color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? color : color.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(trigger)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Trigger")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                ZStack {
                                        Circle()
                        .stroke(isSelected ? color : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                                            .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Routine Card
struct RoutineCard: View {
    let routine: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                                                Circle()
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                
                Text(routine)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
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
        ("Discover flare triggers", "magnifyingglass.circle.fill"),
        ("Reduce symptom severity", "arrow.down.circle.fill"),
        ("Track treatment effectiveness", "chart.line.uptrend.xyaxis"),
        ("Share data with doctors", "square.and.arrow.up.fill")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Your Goals")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("What do you want most from this app?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Goals options
            VStack(spacing: 12) {
                ForEach(goals, id: \.0) { goal in
                    GoalCard(
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
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .onAppear {
            // Set default completion action when this view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // This will be handled by the parent view's navigation button
            }
        }
    }
}

// MARK: - Goal Card
struct GoalCard: View {
    let goal: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .purple : .gray)
                }
                
                Text(goal)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.purple : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.purple)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - New Completion View
struct NewCompletionView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success animation
            VStack(spacing: 24) {
                ZStack {
                                                Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 16) {
                    Text("You're All Set!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Your personalized health tracking experience is ready")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            // What's next
            VStack(spacing: 20) {
                Text("What's Next?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 16) {
                    NextStepRow(
                        icon: "heart.fill",
                        title: "Start Tracking",
                        description: "Begin logging your daily symptoms",
                        color: .red
                    )
                    
                    NextStepRow(
                        icon: "bell.fill",
                        title: "Set Reminders",
                        description: "Never miss medication or check-ins",
                        color: .blue
                    )
                    
                    NextStepRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "View Insights",
                        description: "See patterns in your health data",
                        color: .green
                    )
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            )
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Next Step Row
struct NextStepRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                }
                
                Spacer()
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
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
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Welcome Card
                    VStack(spacing: 24) {
                        // Icon
                                            ZStack {
                                                        Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 48, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        
                        // Title and Description
                        VStack(spacing: 12) {
                    Text("Welcome to")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                    
                    Text("your personal")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("health tracker")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                            
                            Text("Let's set up your personalized health tracking experience")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Features Preview
                    VStack(spacing: 16) {
                        Text("What you'll get")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            FeatureRow(
                                icon: "heart.fill",
                                title: "Symptom Tracking",
                                description: "Monitor your symptoms daily",
                                color: .red
                            )
                            
                            FeatureRow(
                                icon: "pills.fill",
                                title: "Medication Reminders",
                                description: "Never miss a dose",
                                color: .blue
                            )
                            
                            FeatureRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Health Insights",
                                description: "Understand your patterns",
                                color: .green
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                }
                
                Spacer()
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
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Title Card
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "heart.text.square")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.blue)
                            
                            Text("Your Conditions")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    Text("Help us understand your health profile")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Conditions Grid
                    VStack(spacing: 16) {
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
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    
                            Image(systemName: "plus")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                            
                                VStack(alignment: .leading, spacing: 4) {
                            Text("Add another condition")
                                        .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                    
                                    Text("Tap to add a custom condition")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            
                            Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                        }
                            .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
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
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                Text(condition)
                        .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    
                    Text("Health condition")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
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
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Title Card
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "heart.text.square")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.blue)
                            
                            Text("Track Your Symptoms")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    Text("Select symptoms you experience regularly")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    
                    TextField("Search symptoms...", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Symptoms Categories
                VStack(spacing: 24) {
                    // Vision & Eye Category
                    VStack(alignment: .leading, spacing: 16) {
                            HStack {
                        Text("Vision & Eye")
                                    .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                        
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
                            .padding(.horizontal, 24)
                    }
                    
                    // Skin & Dermatological Category
                    VStack(alignment: .leading, spacing: 16) {
                            HStack {
                        Text("Skin & Dermatological")
                                    .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                        
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
                            .padding(.horizontal, 24)
                    }
                }
                    
                    Spacer(minLength: 100)
            }
        }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
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
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Title Card
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.blue)
                            
                            Text("Flare Frequency")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    Text("How often do your symptoms flare up?")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                // Frequency Options
                    VStack(spacing: 16) {
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
                    .padding(.horizontal, 24)
            
                    Spacer(minLength: 100)
        }
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
}

// MARK: - Modern Frequency Card
struct ModernFrequencyCard: View {
    let frequency: String
    let isSelected: Bool
    let onTap: () -> Void
    
    private var frequencyIcon: String {
        switch frequency {
        case "Constant": return "circle.fill"
        case "Intermittent": return "circle.lefthalf.filled"
        case "Occasionally": return "circle.dotted"
        case "Sporadic": return "circle"
        default: return "circle"
        }
    }
    
    private var frequencyColor: Color {
        switch frequency {
        case "Constant": return .red
        case "Intermittent": return .orange
        case "Occasionally": return .yellow
        case "Sporadic": return .green
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? frequencyColor.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: frequencyIcon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? frequencyColor : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                Text(frequency)
                        .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                    Text("Symptom frequency")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
            Spacer()
            
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? frequencyColor : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(frequencyColor)
                    }
                }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? frequencyColor : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
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
                                Text("Symptoms Scale")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text("Fatigue")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("7/10")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.red)
                                    }
                                    
                                    HStack {
                                        Text("Pain")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("5/10")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.orange)
                                    }
                                    
                                    HStack {
                                        Text("Brain Fog")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("3/10")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.yellow)
                                    }
                                }
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
    @State private var selectedTherapyType: TherapyType = .mental
    @State private var moodRating = 3
    @State private var stressLevel = 3
    @State private var therapyNotes = ""
    @State private var showingTherapySession = false
    @State private var selectedActivities: Set<String> = []
    @State private var painLevel = 3
    @State private var flexibilityLevel = 3
    @State private var strengthLevel = 3
    @State private var sessionDuration = 30
    @State private var therapistName = ""
    
    enum TherapyType: String, CaseIterable {
        case mental = "Mental Health"
        case physical = "Physical Therapy"
        case combined = "Combined"
        
        var icon: String {
            switch self {
            case .mental: return "🧠"
            case .physical: return "💪"
            case .combined: return "🔄"
            }
        }
        
        var color: Color {
            switch self {
            case .mental: return .blue
            case .physical: return .green
            case .combined: return .purple
            }
        }
    }
    
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
    
    private let levelOptions = [
        (1, "Very Poor", Color.red),
        (2, "Poor", Color.orange),
        (3, "Fair", Color.yellow),
        (4, "Good", Color.green),
        (5, "Excellent", Color.blue)
    ]
    
    private let mentalTherapyActivities = [
        "Meditation", "Deep Breathing", "Journaling", "Cognitive Therapy",
        "Reading", "Music Therapy", "Nature Walk", "Art Therapy",
        "Mindfulness", "Progressive Relaxation", "Guided Imagery", "Breathing Exercises"
    ]
    
    private let physicalTherapyActivities = [
        "Stretching", "Strength Training", "Balance Exercises", "Range of Motion",
        "Massage Therapy", "Heat/Cold Therapy", "Aquatic Therapy", "Manual Therapy",
        "Posture Correction", "Core Strengthening", "Joint Mobilization", "Gait Training"
    ]
    
    private var currentActivities: [String] {
        switch selectedTherapyType {
        case .mental:
            return mentalTherapyActivities
        case .physical:
            return physicalTherapyActivities
        case .combined:
            return mentalTherapyActivities + physicalTherapyActivities
        }
    }
    
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
                    
                    // Therapy Type Selector
                    VStack(spacing: 16) {
                        Text("Therapy Type")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 12) {
                            ForEach(TherapyType.allCases, id: \.self) { type in
                                Button(action: {
                                    selectedTherapyType = type
                                }) {
                                    VStack(spacing: 8) {
                                        Text(type.icon)
                                            .font(.system(size: 24))
                                        
                                        Text(type.rawValue)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedTherapyType == type ? type.color.opacity(0.2) : Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedTherapyType == type ? type.color : Color.clear, lineWidth: 2)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Dynamic Summary based on Therapy Type
                    VStack(spacing: 20) {
                        if selectedTherapyType == .mental || selectedTherapyType == .combined {
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
                        
                        if selectedTherapyType == .physical || selectedTherapyType == .combined {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Pain Level")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    HStack(spacing: 8) {
                                        Text("🩹")
                                            .font(.system(size: 32))
                                        
                                        Text(levelOptions[painLevel - 1].1)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(levelOptions[painLevel - 1].2)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text("Flexibility")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text(levelOptions[flexibilityLevel - 1].1)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(levelOptions[flexibilityLevel - 1].2)
                                }
                            }
                        }
                        
                        // Session Duration & Therapist
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Session Duration")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("\(sessionDuration) minutes")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("Therapist")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text(therapistName.isEmpty ? "Not specified" : therapistName)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.blue)
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
                    
                    // Mood Rating (Mental & Combined)
                    if selectedTherapyType == .mental || selectedTherapyType == .combined {
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
                    }
                    
                    // Stress Level (Mental & Combined)
                    if selectedTherapyType == .mental || selectedTherapyType == .combined {
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
                    }
                    
                    // Physical Therapy Ratings
                    if selectedTherapyType == .physical || selectedTherapyType == .combined {
                        VStack(spacing: 24) {
                            // Pain Level
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Pain Level")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Current Pain")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Text(levelOptions[painLevel - 1].1)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(levelOptions[painLevel - 1].2)
                                    }
                                    
                                    HStack {
                                        ForEach(levelOptions, id: \.0) { option in
                                            Button(action: {
                                                painLevel = option.0
                                            }) {
                                                Circle()
                                                    .fill(painLevel == option.0 ? option.2 : Color.gray.opacity(0.3))
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        Text("\(option.0)")
                                                            .font(.system(size: 16, weight: .bold))
                                                            .foregroundColor(painLevel == option.0 ? .white : .gray)
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
                            
                            // Flexibility Level
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Flexibility Level")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Current Flexibility")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Text(levelOptions[flexibilityLevel - 1].1)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(levelOptions[flexibilityLevel - 1].2)
                                    }
                                    
                                    HStack {
                                        ForEach(levelOptions, id: \.0) { option in
                                            Button(action: {
                                                flexibilityLevel = option.0
                                            }) {
                                                Circle()
                                                    .fill(flexibilityLevel == option.0 ? option.2 : Color.gray.opacity(0.3))
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        Text("\(option.0)")
                                                            .font(.system(size: 16, weight: .bold))
                                                            .foregroundColor(flexibilityLevel == option.0 ? .white : .gray)
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
                            
                            // Strength Level
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Strength Level")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Current Strength")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Text(levelOptions[strengthLevel - 1].1)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(levelOptions[strengthLevel - 1].2)
                                    }
                                    
                                    HStack {
                                        ForEach(levelOptions, id: \.0) { option in
                                            Button(action: {
                                                strengthLevel = option.0
                                            }) {
                                                Circle()
                                                    .fill(strengthLevel == option.0 ? option.2 : Color.gray.opacity(0.3))
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        Text("\(option.0)")
                                                            .font(.system(size: 16, weight: .bold))
                                                            .foregroundColor(strengthLevel == option.0 ? .white : .gray)
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
                        }
                        .padding(.bottom, 24)
                    }
                    
                    // Session Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Session Details")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            // Session Duration
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Session Duration")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Text("\(sessionDuration) minutes")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            if sessionDuration > 5 {
                                                sessionDuration -= 5
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Button(action: {
                                            if sessionDuration < 120 {
                                                sessionDuration += 5
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                            
                            // Therapist Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Therapist Name")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Enter therapist name", text: $therapistName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                            ForEach(currentActivities, id: \.self) { activity in
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
                                            .fill(selectedActivities.contains(activity) ? selectedTherapyType.color : Color.gray.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)
                    
                    // Therapy Tips (Dynamic based on type)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(selectedTherapyType.rawValue) Tips")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            if selectedTherapyType == .mental || selectedTherapyType == .combined {
                                TherapyTipRow(icon: "heart.fill", tip: "Practice gratitude daily", color: .blue)
                                TherapyTipRow(icon: "leaf.fill", tip: "Spend time in nature", color: .blue)
                                TherapyTipRow(icon: "person.2.fill", tip: "Connect with loved ones", color: .blue)
                                TherapyTipRow(icon: "book.fill", tip: "Read something inspiring", color: .blue)
                            }
                            
                            if selectedTherapyType == .physical || selectedTherapyType == .combined {
                                TherapyTipRow(icon: "figure.strengthtraining.traditional", tip: "Stay consistent with exercises", color: .green)
                                TherapyTipRow(icon: "thermometer", tip: "Use heat/cold therapy as needed", color: .green)
                                TherapyTipRow(icon: "figure.walk", tip: "Take regular movement breaks", color: .green)
                                TherapyTipRow(icon: "drop.fill", tip: "Stay hydrated throughout the day", color: .green)
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
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
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
    @State private var selectedTherapyType: TherapyType = .mental
    @State private var therapistName = ""
    @State private var sessionDuration = 30
    @State private var sessionGoals = ""
    
    enum TherapyType: String, CaseIterable {
        case mental = "Mental Health"
        case physical = "Physical Therapy"
        case combined = "Combined"
        
        var icon: String {
            switch self {
            case .mental: return "🧠"
            case .physical: return "💪"
            case .combined: return "🔄"
            }
        }
        
        var color: Color {
            switch self {
            case .mental: return .blue
            case .physical: return .green
            case .combined: return .purple
            }
        }
    }
    
    private let sessionTypes = ["Individual", "Group", "Family", "Couples"]
    
    var body: some View {
        NavigationView {
            ScrollView {
            VStack(spacing: 24) {
                    // Therapy Type Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Therapy Type")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 12) {
                            ForEach(TherapyType.allCases, id: \.self) { type in
                                Button(action: {
                                    selectedTherapyType = type
                                }) {
                                    VStack(spacing: 4) {
                                        Text(type.icon)
                                            .font(.system(size: 20))
                                        
                                        Text(type.rawValue)
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedTherapyType == type ? type.color.opacity(0.2) : Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedTherapyType == type ? type.color : Color.clear, lineWidth: 2)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    // Session Type
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
                
                    // Therapist Name
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Therapist Name")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextField("Enter therapist name", text: $therapistName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Session Duration
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Session Duration")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("\(sessionDuration) minutes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(selectedTherapyType.color)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    if sessionDuration > 5 {
                                        sessionDuration -= 5
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedTherapyType.color)
                                }
                                
                                Button(action: {
                                    if sessionDuration < 120 {
                                        sessionDuration += 5
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedTherapyType.color)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Session Goals
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Session Goals")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        TextField("What do you hope to achieve in this session?", text: $sessionGoals, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    // Session Notes
                VStack(alignment: .leading, spacing: 16) {
                    Text("Session Notes")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("How did the session go? What did you discuss?", text: $sessionNotes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(5...10)
                }
                
                    // Save Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Session")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                            .background(selectedTherapyType.color)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            }
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
    @State private var selectedSymptoms: Set<String> = []
    @State private var symptomSeverities: [String: Double] = [:]
    @State private var showingAddSymptom = false
    @State private var searchText = ""
    
    private let commonSymptoms = [
        SymptomItem(name: "Fatigue", category: "General", icon: "😴", color: .orange),
        SymptomItem(name: "Pain", category: "Physical", icon: "🤕", color: .red),
        SymptomItem(name: "Brain Fog", category: "Cognitive", icon: "🧠", color: .purple),
        SymptomItem(name: "Nausea", category: "Digestive", icon: "🤢", color: .green),
        SymptomItem(name: "Headache", category: "Physical", icon: "🤯", color: .blue),
        SymptomItem(name: "Dizziness", category: "Physical", icon: "🌀", color: .yellow),
        SymptomItem(name: "Joint Pain", category: "Physical", icon: "🦴", color: .brown),
        SymptomItem(name: "Muscle Weakness", category: "Physical", icon: "💪", color: .gray)
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
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Search symptoms...", text: $searchText)
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
                    
                    // Today's Symptoms
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Symptoms")
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
                                
                                Text("Add your symptoms to track them")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(Array(selectedSymptoms), id: \.self) { symptomName in
                                    if let symptom = commonSymptoms.first(where: { $0.name == symptomName }) {
                                        SymptomTrackingRow(
                                            symptom: symptom,
                                            severity: Binding(
                                                get: { symptomSeverities[symptomName] ?? 0 },
                                                set: { symptomSeverities[symptomName] = $0 }
                                            ),
                                            onRemove: {
                                                selectedSymptoms.remove(symptomName)
                                                symptomSeverities.removeValue(forKey: symptomName)
                                            }
                                        )
                                    }
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
                            ForEach(commonSymptoms, id: \.name) { symptom in
                                Button(action: {
                                    if selectedSymptoms.contains(symptom.name) {
                                        selectedSymptoms.remove(symptom.name)
                                        symptomSeverities.removeValue(forKey: symptom.name)
                                    } else {
                                        selectedSymptoms.insert(symptom.name)
                                        if symptomSeverities[symptom.name] == nil {
                                            symptomSeverities[symptom.name] = 5
                                        }
                                    }
                                }) {
                                    SymptomAddCard(symptom: symptom, isSelected: selectedSymptoms.contains(symptom.name))
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
        .sheet(isPresented: $showingAddSymptom) {
            AddSymptomView(symptoms: $selectedSymptoms, severities: $symptomSeverities)
        }
    }
}

// MARK: - Symptom Item Model
struct SymptomItem: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let icon: String
    let color: Color
}

// MARK: - Symptom Tracking Row
struct SymptomTrackingRow: View {
    let symptom: SymptomItem
    @Binding var severity: Double
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Symptom Icon
                ZStack {
                    Circle()
                        .fill(symptom.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(symptom.icon)
                        .font(.system(size: 24))
                }
                
                // Symptom Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(symptom.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text(symptom.category)
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
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Severity")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("\(Int(severity))/10")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(severityColor)
                }
                
                Slider(value: $severity, in: 0...10, step: 1)
                    .accentColor(severityColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
    
    private var severityColor: Color {
        switch severity {
        case 0...2: return .green
        case 3...4: return .yellow
        case 5...6: return .orange
        case 7...8: return .red
        default: return .purple
        }
    }
}

// MARK: - Symptom Add Card
struct SymptomAddCard: View {
    let symptom: SymptomItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(symptom.color.opacity(isSelected ? 0.3 : 0.2))
                    .frame(width: 40, height: 40)
                
                Text(symptom.icon)
                    .font(.system(size: 20))
            }
            
            VStack(spacing: 4) {
                Text(symptom.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(symptom.category)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? symptom.color.opacity(0.1) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? symptom.color : Color.clear, lineWidth: 2)
                )
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
    @State private var category = "General"
    @State private var severity = 5.0
    
    private let categories = ["General", "Physical", "Cognitive", "Digestive", "Emotional", "Sleep"]
    
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
                    Text("Category")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
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
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Initial Severity")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("\(Int(severity))/10")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.red)
                    }
                    
                    Slider(value: $severity, in: 0...10, step: 1)
                        .accentColor(.red)
                }
                
                Spacer()
                
                Button(action: {
                    symptoms.insert(symptomName)
                    severities[symptomName] = severity
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


// MARK: - Onboarding Summary View
struct OnboardingSummaryView: View {
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
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Review Your Setup")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Let's make sure everything looks good")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 24)
            
            // Summary content
            ScrollView {
                VStack(spacing: 20) {
                    // Profile summary
                    SummarySection(
                        title: "Profile",
                        icon: "person.fill",
                        color: .blue
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(userName.isEmpty ? "Not provided" : userName)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Conditions summary
                    if !selectedConditions.isEmpty {
                        SummarySection(
                            title: "Chronic Illness",
                            icon: "heart.fill",
                            color: .red
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(selectedConditions), id: \.self) { condition in
                                    Text("• \(condition)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // Symptoms summary
                    if !selectedSymptoms.isEmpty {
                        SummarySection(
                            title: "Symptoms",
                            icon: "bandage.fill",
                            color: .orange
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(selectedSymptoms), id: \.self) { symptom in
                                    Text("• \(symptom)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // Flare pattern summary
                    SummarySection(
                        title: "Flare Pattern",
                        icon: "waveform.path.ecg",
                        color: .purple
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• \(flareFrequency.isEmpty ? "Not selected" : flareFrequency)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Triggers summary
                    if !selectedTriggers.isEmpty {
                        SummarySection(
                            title: "Triggers to Track",
                            icon: "exclamationmark.triangle.fill",
                            color: .yellow
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(selectedTriggers), id: \.self) { trigger in
                                    Text("• \(trigger)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // Routines summary
                    if !selectedRoutines.isEmpty {
                        SummarySection(
                            title: "Things You Want to Track",
                            icon: "checkmark.circle.fill",
                            color: .green
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(selectedRoutines), id: \.self) { routine in
                                    Text("• \(routine)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // Goals summary
                    if !selectedGoals.isEmpty {
                        SummarySection(
                            title: "Your Goals",
                            icon: "target",
                            color: .indigo
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(selectedGoals), id: \.self) { goal in
                                    Text("• \(goal)")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
        }
    }
}

// MARK: - Summary Section
struct SummarySection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}