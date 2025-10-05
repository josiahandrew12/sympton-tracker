#!/usr/bin/env python3
import re

def fix_timeline_completely():
    """Remove TimelineView.swift completely and re-add it properly"""
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Remove all TimelineView.swift entries completely
    # Remove PBXBuildFile entry
    content = re.sub(r'\t\tB324E44B9E5441F7A14A6886 /\* TimelineView\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 6D448B68C1534580B340430F /\* TimelineView\.swift \*/; \};\n', '', content)

    # Remove PBXFileReference entry
    content = re.sub(r'\t\t6D448B68C1534580B340430F /\* TimelineView\.swift \*/ = \{isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = "[^"]*"; sourceTree = "<group>"; \};\n', '', content)

    # Remove from Sources build phase
    content = re.sub(r'\t\t\t\tB324E44B9E5441F7A14A6886 /\* TimelineView\.swift in Sources \*/,\n', '', content)

    # Now add it back with correct structure
    file_ref_id = "6D448B68C1534580B340430F"
    build_file_id = "B324E44B9E5441F7A14A6886"

    # Add PBXBuildFile entry
    build_file_entry = f"\t\t{build_file_id} /* TimelineView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* TimelineView.swift */; }};"

    build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/.*?)(/\* End PBXBuildFile section \*/)', content, re.DOTALL)
    if build_file_section:
        new_build_file_section = build_file_section.group(1) + "\n" + build_file_entry + "\n" + build_file_section.group(2)
        content = content.replace(build_file_section.group(0), new_build_file_section)

    # Add PBXFileReference entry
    file_ref_entry = f"\t\t{file_ref_id} /* TimelineView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"SymptomTracker/Views/Components/TimelineView.swift\"; sourceTree = \"<group>\"; }};"

    file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?)(/\* End PBXFileReference section \*/)', content, re.DOTALL)
    if file_ref_section:
        new_file_ref_section = file_ref_section.group(1) + "\n" + file_ref_entry + "\n" + file_ref_section.group(2)
        content = content.replace(file_ref_section.group(0), new_file_ref_section)

    # Add to Sources build phase
    sources_phase = re.search(r'(7340D9352E72656C00E1872B /\* Sources \*/ = \{.*?files = \(.*?)(\);)', content, re.DOTALL)
    if sources_phase:
        new_sources_phase = sources_phase.group(1) + f"\n\t\t\t\t{build_file_id} /* TimelineView.swift in Sources */," + sources_phase.group(2)
        content = content.replace(sources_phase.group(0), new_sources_phase)

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print("Completely removed and re-added TimelineView.swift with correct path!")

if __name__ == "__main__":
    fix_timeline_completely()