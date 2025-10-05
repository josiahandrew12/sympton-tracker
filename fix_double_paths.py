#!/usr/bin/env python3
import re

def fix_double_symptom_tracker_paths():
    """Fix double SymptomTracker paths in Xcode project"""
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Fix all instances of SymptomTracker/SymptomTracker to just SymptomTracker
    content = content.replace('SymptomTracker/SymptomTracker/', 'SymptomTracker/')

    # Also fix the pattern where we have "SymptomTracker/Models" etc. instead it should be just relative paths
    # The files should be referenced as just their relative paths from the project root
    files_to_fix = [
        ("SymptomTracker/Models/AppModels.swift", "Models/AppModels.swift"),
        ("SymptomTracker/ViewModels/AppStateManager.swift", "ViewModels/AppStateManager.swift"),
        ("SymptomTracker/Extensions/AppTheme.swift", "Extensions/AppTheme.swift"),
        ("SymptomTracker/Extensions/Color+Extensions.swift", "Extensions/Color+Extensions.swift"),
        ("SymptomTracker/Extensions/ErrorHandling.swift", "Extensions/ErrorHandling.swift"),
        ("SymptomTracker/Extensions/SelectableCardProtocol.swift", "Extensions/SelectableCardProtocol.swift"),
        ("SymptomTracker/Views/Components/ConditionCard.swift", "Views/Components/ConditionCard.swift"),
        ("SymptomTracker/Views/Components/FeaturePreviewRow.swift", "Views/Components/FeaturePreviewRow.swift"),
        ("SymptomTracker/Views/Components/FlarePatternCard.swift", "Views/Components/FlarePatternCard.swift"),
        ("SymptomTracker/Views/Components/FoodItemRow.swift", "Views/Components/FoodItemRow.swift"),
        ("SymptomTracker/Views/Components/GoalCard.swift", "Views/Components/GoalCard.swift"),
        ("SymptomTracker/Views/Components/ModernActionCard.swift", "Views/Components/ModernActionCard.swift"),
        ("SymptomTracker/Views/Components/ModernDayCard.swift", "Views/Components/ModernDayCard.swift"),
        ("SymptomTracker/Views/Components/ModernReminderCard.swift", "Views/Components/ModernReminderCard.swift"),
        ("SymptomTracker/Views/Components/QuickAddButton.swift", "Views/Components/QuickAddButton.swift"),
        ("SymptomTracker/Views/Components/RoutineCard.swift", "Views/Components/RoutineCard.swift"),
        ("SymptomTracker/Views/Components/SummarySection.swift", "Views/Components/SummarySection.swift"),
        ("SymptomTracker/Views/Components/SymptomCardWithScale.swift", "Views/Components/SymptomCardWithScale.swift"),
        ("SymptomTracker/Views/Components/TimelineView.swift", "Views/Components/TimelineView.swift"),
        ("SymptomTracker/Views/Components/TreatmentCard.swift", "Views/Components/TreatmentCard.swift"),
        ("SymptomTracker/Views/Components/TriggerCardFullWidth.swift", "Views/Components/TriggerCardFullWidth.swift"),
        ("SymptomTracker/Views/MainScreens/FoodTrackingView.swift", "Views/MainScreens/FoodTrackingView.swift"),
        ("SymptomTracker/Views/MainScreens/HomeScreenView.swift", "Views/MainScreens/HomeScreenView.swift"),
        ("SymptomTracker/Views/MainScreens/MedicationTrackingView.swift", "Views/MainScreens/MedicationTrackingView.swift"),
        ("SymptomTracker/Views/MainScreens/RestTrackingView.swift", "Views/MainScreens/RestTrackingView.swift"),
        ("SymptomTracker/Views/MainScreens/SymptomsTrackingView.swift", "Views/MainScreens/SymptomsTrackingView.swift"),
        ("SymptomTracker/Views/MainScreens/TherapyTrackingView.swift", "Views/MainScreens/TherapyTrackingView.swift"),
        ("SymptomTracker/Views/Onboarding/OnboardingFlowView.swift", "Views/Onboarding/OnboardingFlowView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/ConditionsView.swift", "Views/Onboarding/Steps/ConditionsView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/FlarePatternView.swift", "Views/Onboarding/Steps/FlarePatternView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/GoalsView.swift", "Views/Onboarding/Steps/GoalsView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/OnboardingSummaryView.swift", "Views/Onboarding/Steps/OnboardingSummaryView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/ProfileSetupView.swift", "Views/Onboarding/Steps/ProfileSetupView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/SymptomsView.swift", "Views/Onboarding/Steps/SymptomsView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/TreatmentsView.swift", "Views/Onboarding/Steps/TreatmentsView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/TriggersView.swift", "Views/Onboarding/Steps/TriggersView.swift"),
        ("SymptomTracker/Views/Onboarding/Steps/WelcomeView.swift", "Views/Onboarding/Steps/WelcomeView.swift")
    ]

    # Fix each file path
    for old_path, new_path in files_to_fix:
        content = content.replace(f'path = "{old_path}";', f'path = "{new_path}";')
        print(f"Fixed {old_path} -> {new_path}")

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print("Fixed all double path references in Xcode project!")

if __name__ == "__main__":
    fix_double_symptom_tracker_paths()