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
    echo -e "${GREEN}Welcome to the Follower Search Tool${NC}"
    echo "This tool allows you to search for users who follow a specific user."

    # New line
    echo

    # Answer for the question (french)
    echo -e "${YELLOW}Question: Écrivez une 'auto-jointure' (jointure de deux copies d'une même table)${NC}"

    # New line
    echo

    # Example user name
    echo "Example:"
    echo -e "${BLUE}Username: 'iwatson'${NC}"

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    username=""

    # Prompt the user for parameters
    while [[ -z "$username" ]]; do
        read -p "Enter the username: " username
        if [[ -z "$username" ]]; then
            echo -e "${RED}Username cannot be empty. Please try again.${NC}"
        fi
    done

    # Call psql with the SQL file and pass parameters correctly
    echo "Searching for users..."
    psql -d "$DATABASE_NAME" -v username="'$username'" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search for another user? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo -e "${GREEN}Exiting the Follower Search Tool...${NC}"
echo "Goodbye!"
