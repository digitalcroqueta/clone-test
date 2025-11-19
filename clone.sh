#!/bin/bash

# -----------------------------------------------------------------------------
# A script to clone multiple repositories from a list in a file.
# -----------------------------------------------------------------------------

# --- Configuration ---
# IMPORTANT: Set your workspace/project name here.
WORKSPACE="microsoft"

# --- Script Logic ---

# 1. Check if a file path was provided as an argument.
if [ -z "$1" ]; then
    echo "❌ Error: No repository list file supplied."
    echo "Usage: $0 ./repos.txt"
    exit 1
fi

REPO_FILE="$1"

# 2. Check if the provided file actually exists.
if [ ! -f "$REPO_FILE" ]; then
    echo "❌ Error: File '$REPO_FILE' not found."
    exit 1
fi

echo "🚀 Starting clone process for repositories in '$REPO_FILE'..."
echo "---------------------------------------------------------"

# 3. Read the file line by line and clone each repository.
while IFS= read -r repo_name || [[ -n "$repo_name" ]]; do
    # Skip empty lines or lines that start with # (comments).
    if [[ -z "$repo_name" ]] || [[ "$repo_name" =~ ^# ]]; then
        continue
    fi

    # Construct the SSH clone URL.
    CLONE_URL="https://github.com/${WORKSPACE}/${repo_name}.git"

    echo "Cloning '$repo_name' from '$CLONE_URL'..."
    git clone "$CLONE_URL"

    # Check the exit status of the git clone command.
    if [ $? -eq 0 ]; then
        echo "✅ Successfully cloned '$repo_name'."
    else
        echo "⚠️  Failed to clone '$repo_name'. Check the repository name and your permissions."
    fi
    echo "" # Add a blank line for better readability.

done < "$REPO_FILE"

echo "---------------------------------------------------------"
echo "🎉 All repositories have been processed."