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
    echo -e "${GREEN}Welcome to the User Post After Date Search Tool${NC}"
    echo "This tool allows you to search for users who have posted after a specific date."

    # New line
    echo

    # Answer for the question (french)
    echo -e "${YELLOW}Question: Écrivez une sous-requête dans le WHERE${NC}"

    # New line
    echo

    # Example minimum number of followers
    echo "Example:"

    # Check if 'date' command supports '-d' (GNU/Linux)
    if date --version &>/dev/null; then
        # GNU date command (Linux)
        DATE_CMD="date -d '4 weeks ago' +%Y-%m-%d"
    else
        # BSD date command (macOS)
        DATE_CMD="date -v-4w +%Y-%m-%d"
    fi

    echo -e "${BLUE}Date: '$($DATE_CMD)'${NC}"
    echo "This example will search for users who have posted after 4 weeks ago."

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    date=""

    # Prompt the user for parameters
    while [[ -z "$date" ]]; do
        read -p "Enter the date (YYYY-MM-DD): " date
        if [[ -z "$date" ]]; then
            echo -e "${RED}Date cannot be empty. Please try again.${NC}"
        fi
    done

    # Call psql with the SQL file and pass parameters correctly
    echo "Searching for users..."
    psql -d "$DATABASE_NAME" -v date="'$date'" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search again? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo -e "${GREEN}Exiting the User Post After Date Search Tool...${NC}"
echo "Goodbye!"
