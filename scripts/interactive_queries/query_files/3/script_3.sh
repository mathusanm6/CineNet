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
    echo -e "${GREEN}Welcome to the At Least Following Search Tool${NC}"
    echo "This tool allows you to search for users who follow at least a specific number of users."

    # New line
    echo

    # Answer for the question (french)
    echo -e "${YELLOW}Question: Écrivez une sous-requête corrélée${NC}"

    # New line
    echo

    # Example minimum number of followers
    echo "Example:"
    echo -e "${BLUE}Minimum number of followers: 7${NC}"

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    min_following_count=""

    # Prompt the user for parameters
    while [[ -z "$min_following_count" ]]; do
        read -p "Enter the minimum number of followers: " min_following_count
        if [[ -z "$min_following_count" ]]; then
            echo -e "${RED}Minimum number of followers cannot be empty. Please try again.${NC}"
        fi
    done

    # Call psql with the SQL file and pass parameters correctly
    echo "Searching for users..."
    psql -d "$DATABASE_NAME" -v minfollowingcount="'$min_following_count'" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search again? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo "Exiting the At Least Following Search Tool..."
echo "Goodbye!"
