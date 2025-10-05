#!/usr/bin/env python3
import re

def fix_timeline_path():
    """Fix TimelineView.swift path in Xcode project"""
    project_path = "/Users/josiahcornelius/god-mode/sympton-tracker/SymptomTracker.xcodeproj/project.pbxproj"

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Fix the TimelineView.swift path
    content = re.sub(
        r'6D448B68C1534580B340430F /\* TimelineView\.swift \*/ = \{isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = TimelineView\.swift; sourceTree = "<group>"; \};',
        '6D448B68C1534580B340430F /* TimelineView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Views/Components/TimelineView.swift"; sourceTree = "<group>"; };',
        content
    )

    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)

    print("Fixed TimelineView.swift path in Xcode project!")

if __name__ == "__main__":
    fix_timeline_path()