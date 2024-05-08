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
    echo -e "${GREEN}Welcome to the Users Reacting to Every Single Post of a Given User Search Tool${NC}"
    echo "This tool allows you to list all users who reacted to every single post of a given user."

    # New line
    echo

    # Answer for the question (french)
    echo -e "${YELLOW}Question: Écrivez deux requêtes équivalentes exprimant une condition de totalité (Avec de l'aggrégation)${NC}"

    # New line
    echo

    # Example minimum number of followers
    echo "Example:"
    echo -e "${BLUE}User id: '27'${NC}"

    echo

    # Set the database name
    DATABASE_NAME="cinenetdb"

    # Ensure variables are reset each time through the loop
    user_id=""

    # Prompt the user for parameters
    read -p "Enter the user ID: " user_id

    # Check if the user ID is empty
    if [[ -z "$user_id" ]]; then
        echo -e "${RED}Error: User ID cannot be empty.${NC}"
        continue
    fi

    # Call psql with the SQL file and pass parameters correctly
    echo "Listing all users who reacted to every single post of user..."
    psql -d "$DATABASE_NAME" -v userid="'$user_id'" -f "$folder_path/$sql_file"

    # Success message
    echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
    echo

    # Ask the user if they want to search again
    read -p "Do you want to search again? (y/n): " search_again
    if [[ "$search_again" != "y" ]]; then
        break
    fi
done

echo "Exiting the Users Reacting to Every Single Post of a Given User Search Tool..."
echo "Goodbye!"