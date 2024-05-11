#!/bin/bash

# Parameters for the script
folder_path=$1
choice=$2

# SQL file for the script
sql_file="sql_$choice.sql"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to clear the terminal screen
clear_screen() {
    echo -e "\033[2J\033[1;1H"
}

while true; do

    # Clear the terminal
    clear_screen

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
    echo -e "${BLUE}Event name: 'True/False Film Fest'${NC}"
    echo -e "${BLUE}Living and Event Country name: 'Nigeria'${NC}"

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    event_name=""
    country_name=""

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
    psql -d "$DATABASE_NAME" -v eventname="'$event_name'" -v countryname="'$country_name'" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search again? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo -e "${GREEN}Exiting the Event Search Tool...${NC}"
echo "Goodbye!"
