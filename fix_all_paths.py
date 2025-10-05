#!/usr/bin/env python3
import re

def fix_all_file_paths():
    """Fix all file paths in Xcode project to include SymptomTracker prefix"""
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # List of all paths that need fixing (without SymptomTracker/ prefix)
    files_to_fix = [
        "Models/AppModels.swift",
        "ViewModels/AppStateManager.swift",
        "Extensions/AppTheme.swift",
        "Extensions/Color+Extensions.swift",
        "Extensions/ErrorHandling.swift",
        "Extensions/SelectableCardProtocol.swift",
        "Views/Components/ConditionCard.swift",
        "Views/Components/FeaturePreviewRow.swift",
        "Views/Components/FlarePatternCard.swift",
        "Views/Components/FoodItemRow.swift",
        "Views/Components/GoalCard.swift",
        "Views/Components/ModernActionCard.swift",
        "Views/Components/ModernDayCard.swift",
        "Views/Components/ModernReminderCard.swift",
        "Views/Components/QuickAddButton.swift",
        "Views/Components/RoutineCard.swift",
        "Views/Components/SummarySection.swift",
        "Views/Components/SymptomCardWithScale.swift",
        "Views/Components/TimelineView.swift",
        "Views/Components/TreatmentCard.swift",
        "Views/Components/TriggerCardFullWidth.swift",
        "Views/MainScreens/FoodTrackingView.swift",
        "Views/MainScreens/HomeScreenView.swift",
        "Views/MainScreens/MedicationTrackingView.swift",
        "Views/MainScreens/RestTrackingView.swift",
        "Views/MainScreens/SymptomsTrackingView.swift",
        "Views/MainScreens/TherapyTrackingView.swift",
        "Views/Onboarding/OnboardingFlowView.swift",
        "Views/Onboarding/Steps/ConditionsView.swift",
        "Views/Onboarding/Steps/FlarePatternView.swift",
        "Views/Onboarding/Steps/GoalsView.swift",
        "Views/Onboarding/Steps/OnboardingSummaryView.swift",
        "Views/Onboarding/Steps/ProfileSetupView.swift",
        "Views/Onboarding/Steps/SymptomsView.swift",
        "Views/Onboarding/Steps/TreatmentsView.swift",
        "Views/Onboarding/Steps/TriggersView.swift",
        "Views/Onboarding/Steps/WelcomeView.swift"
    ]

    # Fix each file path by adding SymptomTracker/ prefix
    for file_path in files_to_fix:
        # Fix PBXFileReference path
        old_path_pattern = f'path = "{file_path}";'
        new_path_pattern = f'path = "SymptomTracker/{file_path}";'
        content = content.replace(old_path_pattern, new_path_pattern)

        # Also try without quotes in case some don't have them
        old_path_pattern2 = f'path = {file_path};'
        new_path_pattern2 = f'path = "SymptomTracker/{file_path}";'
        content = content.replace(old_path_pattern2, new_path_pattern2)

        print(f"Fixed path for {file_path}")

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print("Fixed all file paths in Xcode project!")

if __name__ == "__main__":
    fix_all_file_paths()