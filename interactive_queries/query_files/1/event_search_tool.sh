#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Welcome message
echo -e "${GREEN}Welcome to the Event Search Tool${NC}"
echo "This tool allows you to search for users who are participating in an scheduled event in a specific country."

# New line
echo

# Answer for the question (french)
echo -e "${YELLOW}Question: Écrivez une requête qui porte sur au moins trois tables${NC}"

# New line
echo

# Example event name and country name
echo "Example:"
echo -e "${BLUE}Event name: 'Exhibition moment'${NC}"
echo -e "${BLUE}Country name: 'Andorra'${NC}"

echo

# Set the database name
DATABASE_NAME="cinenetdb"

# Prompt the user for parameters
while [[ -z "$event_name" ]]; do
    read -p "Enter the event name: " event_name
    if [[ -z "$event_name" ]]; then
        echo -e "${RED}Event name cannot be empty. Please try again.${NC}"
    fi
done

while [[ -z "$country_name" ]]; do
    read -p "Enter the country name: " country_name
    if [[ -z "$country_name" ]]; then
        echo -e "${RED}Country name cannot be empty. Please try again.${NC}"
    fi
done

folder_path=$1

# Call psql with the SQL file and pass parameters correctly
echo "Searching for events..."
psql -d "$DATABASE_NAME" -v eventname="'$event_name'" -v countryname="'$country_name'" -f "$folder_path/event_search_tool.sql"

# Success message
echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
