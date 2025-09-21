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
            HomeScreenView()
        }
    }
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
        VStack(spacing: 0) {
            // Modern Progress indicator
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    ForEach(0..<10, id: \.self) { step in
                        Circle()
                            .fill(step <= currentStep ? Color.blue : Color.black.opacity(0.1))
                            .frame(width: 8, height: 8)
                            .scaleEffect(step == currentStep ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: currentStep)
                    }
                }
                
                Text("Step \(currentStep + 1) of 10")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            // Current step content
            ScrollView {
                VStack(spacing: 0) {
                    switch currentStep {
                    case 0:
                        WelcomeView()
                    case 1:
                        WhoAreYouView(userName: $userName)
                    case 2:
                        AddConditionsView(selectedConditions: $selectedConditions)
                    case 3:
                        AddSymptomsView(selectedSymptoms: $selectedSymptoms)
                    case 4:
                        FlareFrequencyView(flareFrequency: $flareFrequency)
                    case 5:
                        TriggersView(selectedTriggers: $selectedTriggers)
                    case 6:
                        DailyRoutinesView(selectedRoutines: $selectedRoutines)
                    case 7:
                        GoalsView(selectedGoals: $selectedGoals, showOnboarding: $showOnboarding)
                    case 8:
                        CompletionView(showOnboarding: $showOnboarding)
                    default:
                        WelcomeView()
                    }
                }
            }
            
            // Navigation buttons
            HStack {
                if currentStep > 0 {
                    Button(action: {
                        withAnimation {
                            currentStep -= 1
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
                if currentStep < 8 {
                    Button(action: {
        withAnimation {
                            currentStep += 1
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.white)
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
    var body: some View {
        ZStack {
            // Brighter light gray background
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header Section
                    VStack(spacing: 24) {
                        Text("Today, Sat Sep 20th")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                        
                        // Calendar Strip
                        HStack(spacing: 16) {
                            // Calendar icon
                            Image(systemName: "calendar")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 12) {
                                ForEach(["M 15", "T 16", "W 17", "T 18", "F 19", "S 20", "S 21"], id: \.self) { day in
                                    VStack(spacing: 6) {
                                        Text(day)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(day == "S 20" ? .white : .black)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                Circle()
                                                    .fill(day == "S 20" ? Color.black : Color.clear)
                                            )
                                        
                                        if day == "S 20" {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.green)
                                        } else {
                                            Spacer()
                                                .frame(height: 12)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Quick Check-in Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Quick Check-in")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        // Scrollable container for Quick Check-in cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                QuickCheckInCard(
                                    icon: "pills.fill",
                                    title: "Medications",
                                    color: Color.purple.opacity(0.2),
                                    iconColor: .purple
                                )
                                
                                QuickCheckInCard(
                                    icon: "person.wave.2.fill",
                                    title: "Symptoms",
                                    color: Color.orange.opacity(0.2),
                                    iconColor: .orange
                                )
                                
                                QuickCheckInCard(
                                    icon: "heart.fill",
                                    title: "Measurement",
                                    color: Color.pink.opacity(0.2),
                                    iconColor: .pink
                                )
                                
                                QuickCheckInCard(
                                    icon: "fork.knife",
                                    title: "Track Meals",
                                    color: Color.green.opacity(0.2),
                                    iconColor: .green
                                )
                                
                                QuickCheckInCard(
                                    icon: "bed.double.fill",
                                    title: "Track Rest",
                                    color: Color.blue.opacity(0.2),
                                    iconColor: .blue
                                )
                                
                                QuickCheckInCard(
                                    icon: "brain.head.profile",
                                    title: "Track Therapy",
                                    color: Color.indigo.opacity(0.2),
                                    iconColor: .indigo
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // Reminders Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Reminders")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 20) {
                            // Morning Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sun.max.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.yellow)
                                    
                                    Text("Morning")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 20)
                                
                                ReminderBoxCard(
                                    icon: "pills.fill",
                                    iconColor: .purple,
                                    title: "Morning Medications",
                                    subtitle: "Last recorded Sep 20, 12:32 PM",
                                    isCompleted: true
                                )
                            }
                            
                            // Noon Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sun.max.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.yellow)
                                    
                                    Text("Noon")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 20)
                                
                                ReminderBoxCard(
                                    icon: "person.wave.2.fill",
                                    iconColor: .orange,
                                    title: "Midday Symptom Check",
                                    subtitle: "Last recorded Sep 20, 12:32 PM",
                                    isCompleted: true
                                )
                            }
                            
                            // Evening Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "moon.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.purple)
                                    
                                    Text("Evening")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 20)
                                
                                ReminderBoxCard(
                                    icon: "pills.fill",
                                    iconColor: .purple,
                                    title: "Evening Medications",
                                    subtitle: "Last recorded Sep 20, 12:32 PM",
                                    isCompleted: true
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Quick Check-in Card
struct QuickCheckInCard: View {
    let icon: String
    let title: String
    let color: Color
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(iconColor)
                .frame(width: 70, height: 70)
                .background(color)
                .cornerRadius(18)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 100, height: 120)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Reminder Box Card
struct ReminderBoxCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.blue)
                    .cornerRadius(8)
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
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}