#!/usr/bin/env python3
import os
import uuid
import re

def generate_xcode_id():
    """Generate a 24-character hex ID used by Xcode"""
    return ''.join([c.upper() for c in str(uuid.uuid4()).replace('-', '')])[:24]

def add_file_to_xcode_project(project_path, file_path, target_name="SymptomTracker"):
    """Add a Swift file to Xcode project"""

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Generate unique IDs for this file
    file_ref_id = generate_xcode_id()
    build_file_id = generate_xcode_id()

    file_name = os.path.basename(file_path)
    relative_path = os.path.relpath(file_path, os.path.dirname(project_path).replace('.xcodeproj', ''))

    # Add PBXBuildFile entry
    build_file_entry = f"\t\t{build_file_id} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_name} */; }};"

    # Find the PBXBuildFile section and add the entry
    build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/.*?)(/\* End PBXBuildFile section \*/)', content, re.DOTALL)
    if build_file_section:
        new_build_file_section = build_file_section.group(1) + "\n" + build_file_entry + "\n" + build_file_section.group(2)
        content = content.replace(build_file_section.group(0), new_build_file_section)

    # Add PBXFileReference entry
    file_ref_entry = f"\t\t{file_ref_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_name}; sourceTree = \"<group>\"; }};"

    # Find the PBXFileReference section and add the entry
    file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?)(/\* End PBXFileReference section \*/)', content, re.DOTALL)
    if file_ref_section:
        new_file_ref_section = file_ref_section.group(1) + "\n" + file_ref_entry + "\n" + file_ref_section.group(2)
        content = content.replace(file_ref_section.group(0), new_file_ref_section)

    # Add to Components group (look for Views/Components group)
    components_group = re.search(r'(/\* Views\/Components \*/ = \{.*?children = \(.*?)(\);)', content, re.DOTALL)
    if components_group:
        new_components_group = components_group.group(1) + f"\n\t\t\t\t{file_ref_id} /* {file_name} */," + components_group.group(2)
        content = content.replace(components_group.group(0), new_components_group)
    else:
        # If no Components group found, try to find any group with existing Swift files
        print("Components group not found, looking for other groups...")

    # Add to Sources build phase
    sources_phase = re.search(r'(/\* Sources \*/ = \{.*?files = \(.*?)(\);)', content, re.DOTALL)
    if sources_phase:
        new_sources_phase = sources_phase.group(1) + f"\n\t\t\t\t{build_file_id} /* {file_name} in Sources */," + sources_phase.group(2)
        content = content.replace(sources_phase.group(0), new_sources_phase)

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"Added {file_name} to Xcode project successfully!")
    return True

if __name__ == "__main__":
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"
    file_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker/Views/Components/TimelineView.swift"

    if os.path.exists(file_path):
        add_file_to_xcode_project(project_path, file_path)
    else:
        print(f"File not found: {file_path}")