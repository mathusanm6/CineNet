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
    echo -e "${GREEN}Welcome to the Top 10 Popular Events Listing Tool${NC}"
    echo "This tool allows you to list the top 10 popular events in a given year."

    # New line
    echo

    # Answer for the question (french)
    echo -e "${YELLOW}Question: Écrivez une requête utilisant le fenêtrage${NC}"

    # New line
    echo

    # Example minimum number of followers
    echo "Example:"
    echo -e "${BLUE}Year: '2024'${NC}"

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    year=""

    # Prompt the user for parameters
    read -p "Enter the year: " year

    # Check if the user ID is empty
    if [[ -z "$year" ]]; then
        echo -e "${RED}Error: Year cannot be empty.${NC}"
        continue
    fi

    # Call psql with the SQL file and pass parameters correctly
    echo "Listing the top 10 popular events in the given year..."
    psql -d "$DATABASE_NAME" -v year="$year" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search again? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo "Exiting the Top 10 Popular Events Listing Tool..."
echo "Goodbye!"
