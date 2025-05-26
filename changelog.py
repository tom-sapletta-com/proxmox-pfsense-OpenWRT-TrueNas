#!/bin/python
import subprocess
import os
import re
from datetime import datetime
from typing import List, Optional, Tuple, Dict


def get_version_from_changelog(file_path="CHANGELOG.md"):
    """Extract the most recent version from the changelog file."""
    try:
        with open(file_path, 'r') as file:
            for line in file:
                match = re.search(r'## \[(.*?)\]', line)
                if match:
                    return match.group(1)
    except FileNotFoundError:
        pass
    return None


def add_version(current_version: str, increment_type: str = "patch") -> str:
    """
    Increment the version number according to semantic versioning.

    Args:
        current_version: The current version string (e.g., "1.2.3")
        increment_type: The part of the version to increment ("major", "minor", or "patch")

    Returns:
        The new version string
    """
    if not current_version:
        return "0.1.0"  # Default starting version

    # Parse version components
    match = re.match(r'^(\d+)\.(\d+)\.(\d+)(-([a-zA-Z0-9.-]+))?(\+([a-zA-Z0-9.-]+))?$', current_version)
    if not match:
        raise ValueError(f"Invalid version format: {current_version}. Expected format: X.Y.Z[-prerelease][+build]")

    major, minor, patch = int(match.group(1)), int(match.group(2)), int(match.group(3))
    prerelease = match.group(5) if match.group(4) else None
    build = match.group(7) if match.group(6) else None

    # Increment appropriate component
    if increment_type == "major":
        major += 1
        minor = 0
        patch = 0
        prerelease = None  # Clear prerelease on major version bump
    elif increment_type == "minor":
        minor += 1
        patch = 0
        prerelease = None  # Clear prerelease on minor version bump
    elif increment_type == "patch":
        patch += 1
        prerelease = None  # Clear prerelease on patch version bump
    elif increment_type.startswith("pre"):
        # Handle prerelease versions
        if prerelease:
            # If it's already a prerelease, try to increment its number
            pre_parts = prerelease.split('.')
            if len(pre_parts) > 1 and pre_parts[-1].isdigit():
                pre_parts[-1] = str(int(pre_parts[-1]) + 1)
                prerelease = '.'.join(pre_parts)
            else:
                prerelease = f"{prerelease}.1"
        else:
            # Start a new prerelease version
            prerelease_type = increment_type[3:] or "alpha"  # Extract alpha/beta/rc or default to alpha
            prerelease = f"{prerelease_type}.1"
    else:
        raise ValueError(
            f"Invalid increment type: {increment_type}. Expected 'major', 'minor', 'patch', or 'pre[type]'")

    # Construct new version
    new_version = f"{major}.{minor}.{patch}"
    if prerelease:
        new_version += f"-{prerelease}"
    if build:
        new_version += f"+{build}"

    return new_version


class ChangelogGenerator:
    def __init__(self):
        version = get_version_from_changelog() or "0.1.0"
        # print(version)
        self.version: str = version
        self.changes: Dict[str, List[str]] = {
            "Added": [],
            "Changed": [],
            "Deprecated": [],
            "Removed": [],
            "Fixed": [],
            "Security": []
        }

    def increment_version(self, increment_type: str = "patch"):
        """
        Increment the version number according to semantic versioning.

        Args:
            increment_type: The part of the version to increment
                            ("major", "minor", "patch", or "pre[type]")
        """
        self.version = add_version(self.version, increment_type)
        return self.version

    def get_git_diff(self, file_path: str, staged: bool = False) -> str:
        """Get git diff for a file."""
        try:
            if not os.path.exists(file_path) and not staged:
                return ""

            cmd = ['git', 'diff']
            if staged:
                cmd.append('--cached')
            cmd.append('--')
            cmd.append(file_path)

            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=False
            )
            return result.stdout
        except subprocess.CalledProcessError:
            return ""

    def analyze_file_changes(self, file_path: str, staged: bool = False) -> str:
        """Analyze file changes to determine the type of change."""
        diff = self.get_git_diff(file_path, staged)

        # Simple rule-based classification
        if not os.path.exists(file_path) and not staged:
            return "Removed"
        elif os.path.exists(file_path) and not staged:
            return "Added" if "+++" in diff else "Changed"

        # For staged files
        if "new file" in diff:
            return "Added"
        elif "deleted file" in diff:
            return "Removed"
        elif "security" in diff.lower() or "vuln" in diff.lower():
            return "Security"
        elif "deprecat" in diff.lower():
            return "Deprecated"
        elif "fix" in diff.lower() or "bug" in diff.lower():
            return "Fixed"
        else:
            return "Changed"

    def add_change(self, change_type: str, message: str):
        """Add a change to the changelog."""
        if change_type in self.changes:
            self.changes[change_type].append(message)

    def generate_changelog(self, staged: bool = False) -> str:
        """Generate a changelog based on git changes."""
        try:
            # Get changed files
            if staged:
                result = subprocess.run(
                    ['git', 'diff', '--cached', '--name-only'],
                    capture_output=True,
                    text=True,
                    check=True
                )
            else:
                result = subprocess.run(
                    ['git', 'ls-files', '--modified', '--others', '--exclude-standard'],
                    capture_output=True,
                    text=True,
                    check=True
                )

            files = result.stdout.strip().split('\n')

            # Analyze each file
            for file in files:
                if file:
                    change_type = self.analyze_file_changes(file, staged)
                    self.add_change(change_type, f"Changes in {file}")

            # Generate markdown
            today = datetime.now().strftime("%Y-%m-%d")
            changelog = f"## [{self.version}] - {today}\n\n"

            for section, changes in self.changes.items():
                if changes:
                    changelog += f"### {section}\n"
                    for change in changes:
                        changelog += f"- {change}\n"
                    changelog += "\n"

            return changelog

        except subprocess.CalledProcessError as e:
            print(f"Error executing git command: {e}")
            return ""

    def update_changelog_file(self, output_file: str = "CHANGELOG.md", staged: bool = False,
                              increment_type: str = None):
        """
        Update the CHANGELOG.md file.

        Args:
            output_file: Path to the changelog file
            staged: Whether to include staged changes only
            increment_type: If provided, increment the version before updating
                           ("major", "minor", "patch", or None to keep current version)
        """
        # Increment version if requested
        if increment_type:
            self.increment_version(increment_type)

        new_changes = self.generate_changelog(staged)
        if not new_changes:
            return

        try:
            existing_content = ""
            if os.path.exists(output_file):
                with open(output_file, 'r', encoding='utf-8') as f:
                    existing_content = f.read()

            with open(output_file, 'w', encoding='utf-8') as f:
                if not existing_content:
                    f.write("# Changelog\n\n")
                    f.write("All notable changes to this project will be documented in this file.\n\n")
                    f.write(new_changes)
                else:
                    # Insert new changes after the header
                    parts = existing_content.split('\n\n', 2)
                    f.write(parts[0] + '\n\n')
                    if len(parts) > 1:
                        f.write(parts[1] + '\n\n')
                    f.write(new_changes)
                    if len(parts) > 2:
                        f.write(parts[2])

        except Exception as e:
            print(f"Error updating changelog file: {e}")


def main():
    generator = ChangelogGenerator()

    # Check for command-line arguments to determine increment type
    import sys
    increment_type = "patch"  # Default increment
    if len(sys.argv) > 1:
        increment_type = sys.argv[1]  # Use provided increment type

    generator.update_changelog_file(staged=True, increment_type=increment_type)
    print(f"Updated changelog to version {generator.version}")


if __name__ == "__main__":
    main()