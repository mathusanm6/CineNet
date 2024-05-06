#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Welcome message
echo -e "${GREEN}Welcome to the Follower Search Tool${NC}"
echo "This tool allows you to search for users who follow a specific user."

# New line
echo

# Example user name
echo "Example:"
echo -e "${BLUE}Username: 'rgross'${NC}"

echo

# Set the database name
DATABASE_NAME="cinenetdb"

# Prompt the user for parameters
while [[ -z "$username" ]]; do
    read -p "Enter the username: " username
    if [[ -z "$username" ]]; then
        echo -e "${RED}Username cannot be empty. Please try again.${NC}"
    fi
done

# Call psql with the SQL file and pass parameters correctly
echo "Searching for events..."
psql -d "$DATABASE_NAME" -v username="'$username'" -f follower_search_tool.sql

# Success message
echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
