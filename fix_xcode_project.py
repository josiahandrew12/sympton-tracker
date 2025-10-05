#!/usr/bin/env python3
import os
import uuid
import re

def generate_xcode_id():
    """Generate a 24-character hex ID used by Xcode"""
    return ''.join([c.upper() for c in str(uuid.uuid4()).replace('-', '')])[:24]

def fix_xcode_project():
    """Add all missing Swift files to the Xcode project"""
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # List of all Swift files that should be in the project
    files_to_add = [
        "AppStateManager.swift",
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

    build_files = []
    file_refs = []
    sources_entries = []

    # Check which files actually exist and generate entries for them
    for file_path in files_to_add:
        full_path = f"/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker/{file_path}"
        if os.path.exists(full_path):
            file_name = os.path.basename(file_path)

            # Skip if already in project
            if file_name in content:
                print(f"Skipping {file_name} - already in project")
                continue

            file_ref_id = generate_xcode_id()
            build_file_id = generate_xcode_id()

            # Add to our lists
            build_files.append(f"\t\t{build_file_id} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_name} */; }};")
            file_refs.append(f"\t\t{file_ref_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"{file_path}\"; sourceTree = \"<group>\"; }};")
            sources_entries.append(f"\t\t\t\t{build_file_id} /* {file_name} in Sources */,")

            print(f"Adding {file_name} to project")

    # Add all build files
    if build_files:
        build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/.*?)(/\* End PBXBuildFile section \*/)', content, re.DOTALL)
        if build_file_section:
            new_build_files = '\n'.join(build_files)
            new_build_file_section = build_file_section.group(1) + "\n" + new_build_files + "\n" + build_file_section.group(2)
            content = content.replace(build_file_section.group(0), new_build_file_section)

    # Add all file references
    if file_refs:
        file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?)(/\* End PBXFileReference section \*/)', content, re.DOTALL)
        if file_ref_section:
            new_file_refs = '\n'.join(file_refs)
            new_file_ref_section = file_ref_section.group(1) + "\n" + new_file_refs + "\n" + file_ref_section.group(2)
            content = content.replace(file_ref_section.group(0), new_file_ref_section)

    # Add to main SymptomTracker group
    symptom_tracker_group = re.search(r'(7340D93B2E72656C00E1872B /\* SymptomTracker \*/ = \{.*?children = \(.*?)(\);)', content, re.DOTALL)
    if symptom_tracker_group and file_refs:
        # Extract file reference IDs and names for the group
        group_entries = []
        for file_ref in file_refs:
            match = re.search(r'(\w+) /\* (.+?) \*/', file_ref)
            if match:
                ref_id, file_name = match.groups()
                group_entries.append(f"\t\t\t\t{ref_id} /* {file_name} */,")

        if group_entries:
            new_group_entries = '\n'.join(group_entries)
            new_group = symptom_tracker_group.group(1) + "\n" + new_group_entries + "\n" + symptom_tracker_group.group(2)
            content = content.replace(symptom_tracker_group.group(0), new_group)

    # Add to Sources build phase
    if sources_entries:
        sources_phase = re.search(r'(7340D9352E72656C00E1872B /\* Sources \*/ = \{.*?files = \(.*?)(\);)', content, re.DOTALL)
        if sources_phase:
            new_sources = '\n'.join(sources_entries)
            new_sources_phase = sources_phase.group(1) + "\n" + new_sources + "\n" + sources_phase.group(2)
            content = content.replace(sources_phase.group(0), new_sources_phase)

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"Successfully added {len([f for f in files_to_add if os.path.exists(f'/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker/{f}')])} files to Xcode project!")

if __name__ == "__main__":
    fix_xcode_project()