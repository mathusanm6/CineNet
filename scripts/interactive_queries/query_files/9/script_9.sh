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
    echo -e "${GREEN}Welcome to the User Participation Event with Status List Tool${NC}"
    echo "This tool allows you to list all users who have expressed interest or are participating in an event with a specific status."
    echo -e "${RED}Possible types of participation: 'Interested', 'Participating'${NC}"
    echo -e "${RED}Possible statuses: 'Scheduled', 'Completed', 'Cancelled'${NC}"

    # New line
    echo

    # Answer for the question (french)
    echo -e "${YELLOW}Question: Écrivez une requête avec une jointure externe (LEFT JOIN)${NC}"

    # New line
    echo

    # Example minimum number of followers
    echo "Example:"
    echo -e "${BLUE}Participation Type: 'Interested'${NC}"
    echo -e "${BLUE}Status: 'Scheduled'${NC}"

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    type_participation=""
    event_status=""

    # Prompt the user for parameters
    while [[ -z "$type_participation" ]]; do
        read -p "Enter the participation type: " type_participation
        if [[ -z "$type_participation" ]]; then
            echo -e "${RED}Participation type cannot be empty. Please try again.${NC}"
        fi
    done

    while [[ -z "$event_status" ]]; do
        read -p "Enter the event status: " event_status
        if [[ -z "$event_status" ]]; then
            echo -e "${RED}Event status cannot be empty. Please try again.${NC}"
        fi
    done

    # Call psql with the SQL file and pass parameters correctly
    echo "Listing all users..."
    psql -d "$DATABASE_NAME" -v typeparticipation="'$type_participation'" -v eventstatus="'$event_status'" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search again? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo "Exiting the User Participation Event with Status List Tool..."
echo "Goodbye!"
