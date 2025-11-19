#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 vikingcloud repos.txt"
    exit 1
fi

WORKSPACE="$1"
REPO_LIST_FILE="$2"

# Check if the repository list file exists
if [ ! -f "$REPO_LIST_FILE" ]; then
    echo "Error: File '$REPO_LIST_FILE' not found."
    exit 1
fi

echo "Starting to clone repositories from Bitbucket workspace: $WORKSPACE"
echo "Reading repository names from: $REPO_LIST_FILE"
echo "----------------------------------------"

# Loop through each line in the repository list file
while IFS= read -r REPO_NAME; do
    # Skip empty lines or lines with only whitespace
    if [[ -z "$REPO_NAME" || "$REPO_NAME" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Construct the full URL for the repository
   REPO_URL="git@bitbucket.org:$WORKSPACE/$REPO_NAME.git"
    
    echo "Cloning repository: $REPO_NAME"
    git clone "$REPO_URL"
    
    # Check if the clone command was successful
    if [ $? -eq 0 ]; then
        echo "Successfully cloned $REPO_NAME."
    else
        echo "Error: Failed to clone $REPO_NAME. Check if the repository exists and you have access."
    fi
    echo "----------------------------------------"
done < "$REPO_LIST_FILE"

echo "Script finished."