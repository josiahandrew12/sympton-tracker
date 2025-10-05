#!/usr/bin/env python3
import re

def remove_duplicate_appstatemanager():
    """Remove duplicate AppStateManager.swift entries from Xcode project"""
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Find and remove the first AppStateManager.swift entry (not in ViewModels)
    # Remove from PBXBuildFile section
    content = re.sub(r'\t\tDECF5917C85741D2B4F2BC0A /\* AppStateManager\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = B41FBB947CAA4DFAB3F1E724 /\* AppStateManager\.swift \*/; \};\n', '', content)

    # Remove from PBXFileReference section
    content = re.sub(r'\t\tB41FBB947CAA4DFAB3F1E724 /\* AppStateManager\.swift \*/ = \{isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = "AppStateManager\.swift"; sourceTree = "<group>"; \};\n', '', content)

    # Remove from SymptomTracker group
    content = re.sub(r'\t\t\t\tB41FBB947CAA4DFAB3F1E724 /\* AppStateManager\.swift \*/,\n', '', content)

    # Remove from Sources build phase
    content = re.sub(r'\t\t\t\tDECF5917C85741D2B4F2BC0A /\* AppStateManager\.swift in Sources \*/,\n', '', content)

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print("Removed duplicate AppStateManager.swift from Xcode project!")

if __name__ == "__main__":
    remove_duplicate_appstatemanager()