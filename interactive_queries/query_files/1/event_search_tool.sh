#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Welcome message
echo -e "${GREEN}Welcome to the Event Search Tool${NC}"
echo "This tool allows you to search for scheduled events by event name and country."

# New line
echo

# Example event name and country name
echo "Example:"
echo -e "${BLUE}Event name: 'Exhibition law'${NC}"
echo -e "${BLUE}Country name: 'Armenia'${NC}"

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

# Call psql with the SQL file and pass parameters correctly
echo "Searching for events..."
psql -d "$DATABASE_NAME" -v eventname="'$event_name'" -v countryname="'$country_name'" -f event_search_tool.sql

# Success message
echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
