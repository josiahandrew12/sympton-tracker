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
        ZStack {
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
                // Profile Complete Page
                ProfileCompleteView(
                    userName: userName,
                    selectedConditions: selectedConditions,
                    selectedSymptoms: selectedSymptoms,
                    severityLevel: severityLevel,
                    flareFrequency: flareFrequency,
                    selectedTriggers: selectedTriggers,
                    selectedGoals: selectedGoals,
                    showOnboarding: $showOnboarding,
                    currentStep: $currentStep
                )
            }
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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Progress indicator
                HStack {
                    ForEach(0..<8, id: \.self) { step in
                        Circle()
                            .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Current step content
                Group {
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
                        SeverityAssessmentView(severityLevel: $severityLevel)
                    case 5:
                        FlareFrequencyView(flareFrequency: $flareFrequency)
                    case 6:
                        TriggersView(selectedTriggers: $selectedTriggers)
                    case 7:
                        GoalsView(selectedGoals: $selectedGoals, showOnboarding: $showOnboarding)
                    default:
                        WelcomeView()
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeInOut(duration: 0.3), value: currentStep)
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                        .foregroundColor(.blue)
                        .padding()
                    }
                    
                    Spacer()
                    
                    if currentStep < 7 {
                        Button("Next") {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Welcome to")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("Symptom Tracker")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Let's help you track and manage your health journey")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

// MARK: - Who Are You View
struct WhoAreYouView: View {
    @Binding var userName: String
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Text("Who are you?")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Take control of your wellness journey with personalized health insights.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            VStack(spacing: 0) {
                TextField("Your name", text: $userName)
                    .font(.title3)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isTextFieldFocused ? Color.blue : Color(.systemGray4), lineWidth: 1)
                            )
                    )
                    .focused($isTextFieldFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isTextFieldFocused = true
                        }
                    }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.top, 60)
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
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                Text("Add conditions")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Instruction box
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Add your conditions")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Adding your conditions helps us recommend symptoms to track.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
            .padding(.horizontal, 40)
            
            VStack(spacing: 16) {
                ForEach(conditions.prefix(2), id: \.self) { condition in
                    Button(action: {
                        if selectedConditions.contains(condition) {
                            selectedConditions.remove(condition)
                        } else {
                            selectedConditions.insert(condition)
                        }
                    }) {
                        HStack {
                            Text(condition)
                                .font(.body)
                                .foregroundColor(selectedConditions.contains(condition) ? .blue : .primary)
                            
                            Spacer()
                            
                            if selectedConditions.contains(condition) {
                                Image(systemName: "checkmark")
                                    .font(.body)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedConditions.contains(condition) ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                )
                        )
                    }
                }
                
                // Add a condition button
                Button(action: {
                    // Add new condition functionality
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Text("Add a condition")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    )
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

// MARK: - Add Symptoms View
struct AddSymptomsView: View {
    @Binding var selectedSymptoms: Set<String>
    @State private var searchText = ""
    
    let visionSymptoms = ["Blurred vision", "Eye pain", "Dry eyes", "Light sensitivity", "Double vision", "Floaters"]
    let skinSymptoms = ["Rash", "Itching", "Dryness", "Redness", "Swelling"]
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                Text("Add Symptoms")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Search field
            HStack {
                Image(systemName: "plus")
                    .font(.body)
                    .foregroundColor(.primary)
                
                TextField("Add Symptoms", text: $searchText)
                    .font(.body)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 40)
            
            // Your Suggestions
            HStack {
                Text("Your Suggestions")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(selectedSymptoms.count) selected")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 40)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Vision & Eye Category
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "eye.fill")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                )
                            
                            Text("Vision & Eye")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(visionSymptoms, id: \.self) { symptom in
                                Button(action: {
                                    if selectedSymptoms.contains(symptom) {
                                        selectedSymptoms.remove(symptom)
                                    } else {
                                        selectedSymptoms.insert(symptom)
                                    }
                                }) {
                                    HStack {
                                        Text(symptom)
                                            .font(.body)
                                            .foregroundColor(selectedSymptoms.contains(symptom) ? .blue : .primary)
                                        
                                        if selectedSymptoms.contains(symptom) {
                                            Image(systemName: "checkmark")
                                                .font(.body)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedSymptoms.contains(symptom) ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                    
                    // Skin & Dermatological Category
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                )
                            
                            Text("Skin & Dermatological")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(skinSymptoms, id: \.self) { symptom in
                                Button(action: {
                                    if selectedSymptoms.contains(symptom) {
                                        selectedSymptoms.remove(symptom)
                                    } else {
                                        selectedSymptoms.insert(symptom)
                                    }
                                }) {
                                    HStack {
                                        Text(symptom)
                                            .font(.body)
                                            .foregroundColor(selectedSymptoms.contains(symptom) ? .blue : .primary)
                                        
                                        if selectedSymptoms.contains(symptom) {
                                            Image(systemName: "checkmark")
                                                .font(.body)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedSymptoms.contains(symptom) ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.top, 60)
    }
}

// MARK: - Severity Assessment View
struct SeverityAssessmentView: View {
    @Binding var severityLevel: Double
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Text("How much do these symptoms affect your daily life?")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Move the slider to rate the impact on your daily activities")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Linear Slider
            VStack(spacing: 20) {
                // Impact level display
                VStack(spacing: 8) {
                    Text("IMPACT LEVEL")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Text("\(Int(severityLevel))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(severityLevel >= 7 ? "SEVERE" : severityLevel >= 4 ? "MODERATE" : "MILD")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                
                // Linear slider
                VStack(spacing: 12) {
                    HStack {
                        Text("1")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("10")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $severityLevel, in: 1...10, step: 1)
                        .accentColor(.blue)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

// MARK: - Flare Frequency View
struct FlareFrequencyView: View {
    @Binding var flareFrequency: String
    
    let frequencies = ["Constant", "Intermittent", "Occasionally", "Sporadic"]
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Text("How often do your symptoms flare up?")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                ForEach(frequencies, id: \.self) { frequency in
                    Button(action: {
                        flareFrequency = frequency
                    }) {
                        HStack {
                            Text(frequency)
                                .font(.body)
                                .foregroundColor(flareFrequency == frequency ? .blue : .primary)
                            
                            Spacer()
                            
                            if flareFrequency == frequency {
                                Image(systemName: "checkmark")
                                    .font(.body)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(flareFrequency == frequency ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

// MARK: - Triggers View
struct TriggersView: View {
    @Binding var selectedTriggers: Set<String>
    @State private var searchText = ""
    
    let dietTriggers = ["Caffeine", "Sugar", "Dairy", "Gluten"]
    let environmentTriggers = ["Work", "Travel", "Exercise", "School"]
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                Text("Triggers You Want to Track")
                    .font(.system(size: 23, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Search field
            HStack {
                Image(systemName: "plus")
                    .font(.body)
                    .foregroundColor(.primary)
                
                TextField("Triggers", text: $searchText)
                    .font(.body)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 40)
            
            // Top Suggestions
            HStack {
                Text("Top Suggestions")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(selectedTriggers.count) selected")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 40)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Diet Category
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "applelogo")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                )
                            
                            Text("Diet")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(dietTriggers, id: \.self) { trigger in
                                Button(action: {
                                    if selectedTriggers.contains(trigger) {
                                        selectedTriggers.remove(trigger)
                                    } else {
                                        selectedTriggers.insert(trigger)
                                    }
                                }) {
                                    HStack {
                                        Text(trigger)
                                            .font(.body)
                                            .foregroundColor(selectedTriggers.contains(trigger) ? .blue : .primary)
                                        
                                        if selectedTriggers.contains(trigger) {
                                            Image(systemName: "checkmark")
                                                .font(.body)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedTriggers.contains(trigger) ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                    
                    // Environment Category
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "cloud.fill")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                )
                            
                            Text("Environment")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(environmentTriggers, id: \.self) { trigger in
                                Button(action: {
                                    if selectedTriggers.contains(trigger) {
                                        selectedTriggers.remove(trigger)
                                    } else {
                                        selectedTriggers.insert(trigger)
                                    }
                                }) {
                                    HStack {
                                        Text(trigger)
                                            .font(.body)
                                            .foregroundColor(selectedTriggers.contains(trigger) ? .blue : .primary)
                                        
                                        if selectedTriggers.contains(trigger) {
                                            Image(systemName: "checkmark")
                                                .font(.body)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedTriggers.contains(trigger) ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.top, 60)
    }
}

// MARK: - Goals View
struct GoalsView: View {
    @Binding var selectedGoals: Set<String>
    @Binding var showOnboarding: Bool
    
    let goals = [
        ("Discover flare triggers", "magnifyingglass"),
        ("Reduce symptom severity", "chart.line.uptrend.xyaxis"),
        ("Track treatments", "chart.bar.fill"),
        ("Share data with doctors", "person.crop.circle.badge.checkmark")
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1),
                    Color.pink.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text("What matters most to you?")
                        .font(.system(size: 23, weight: .bold))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Select all that apply")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 16) {
                    ForEach(goals, id: \.0) { goal in
                        Button(action: {
                            if selectedGoals.contains(goal.0) {
                                selectedGoals.remove(goal.0)
                            } else {
                                selectedGoals.insert(goal.0)
                            }
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: goal.1)
                                    .font(.title2)
                                    .foregroundColor(selectedGoals.contains(goal.0) ? .blue : .primary)
                                    .frame(width: 24, height: 24)
                                
                                Text(goal.0)
                                    .font(.body)
                                    .foregroundColor(selectedGoals.contains(goal.0) ? .blue : .primary)
                                
                                Spacer()
                                
                                if selectedGoals.contains(goal.0) {
                                    Image(systemName: "checkmark")
                                        .font(.body)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedGoals.contains(goal.0) ? Color.blue : Color(.systemGray4), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Complete setup button
                Button("Complete Setup") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showOnboarding = false
                    }
                }
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.black)
                .cornerRadius(12)
                .padding(.bottom, 30)
            }
            .padding(.top, 60)
            
        }
    }
}

// MARK: - Profile Complete View
struct ProfileCompleteView: View {
    let userName: String
    let selectedConditions: Set<String>
    let selectedSymptoms: Set<String>
    let severityLevel: Double
    let flareFrequency: String
    let selectedTriggers: Set<String>
    let selectedGoals: Set<String>
    @Binding var showOnboarding: Bool
    @Binding var currentStep: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Profile Complete!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Hello, \(userName)! Your symptom tracking profile is ready.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Summary Cards
                    VStack(spacing: 20) {
                        // Conditions Card
                        if !selectedConditions.isEmpty {
                            SummaryCard(
                                title: "Conditions",
                                icon: "heart.fill",
                                items: Array(selectedConditions),
                                color: .red
                            )
                        }
                        
                        // Symptoms Card
                        if !selectedSymptoms.isEmpty {
                            SummaryCard(
                                title: "Symptoms",
                                icon: "exclamationmark.triangle.fill",
                                items: Array(selectedSymptoms),
                                color: .orange
                            )
                        }
                        
                        // Severity Card
                        SummaryCard(
                            title: "Impact Level",
                            icon: "gauge.high",
                            items: ["\(Int(severityLevel))/10"],
                            color: severityLevel <= 3 ? .green : severityLevel <= 6 ? .yellow : .red
                        )
                        
                        // Frequency Card
                        SummaryCard(
                            title: "Flare Frequency",
                            icon: "clock.fill",
                            items: [flareFrequency],
                            color: .blue
                        )
                        
                        // Triggers Card
                        if !selectedTriggers.isEmpty {
                            SummaryCard(
                                title: "Triggers to Track",
                                icon: "eye.fill",
                                items: Array(selectedTriggers),
                                color: .purple
                            )
                        }
                        
                        // Goals Card
                        if !selectedGoals.isEmpty {
                            SummaryCard(
                                title: "Your Goals",
                                icon: "target",
                                items: Array(selectedGoals),
                                color: .indigo
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button("Start Tracking") {
                            // Future: Navigate to main tracking interface
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                        
                        Button("Edit Profile") {
                            showOnboarding = true
                            currentStep = 0
                        }
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Summary Card Component
struct SummaryCard: View {
    let title: String
    let icon: String
    let items: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Circle()
                            .fill(color.opacity(0.3))
                            .frame(width: 6, height: 6)
                        
                        Text(item)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
