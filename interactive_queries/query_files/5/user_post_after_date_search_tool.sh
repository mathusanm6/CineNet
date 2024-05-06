#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Welcome message
echo -e "${GREEN}Welcome to the User Post After Date Search Tool${NC}"
echo "This tool allows you to search for users who have posted after a specific date."

# New line
echo

# Answer for the question (french)
echo -e "${YELLOW}Question: Écrivez une une sous-requête dans le WHERE${NC}"

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

# Prompt the user for parameters
while [[ -z "$date" ]]; do
    read -p "Enter the date (YYYY-MM-DD): " date
    if [[ -z "$date" ]]; then
        echo -e "${RED}Date cannot be empty. Please try again.${NC}"
    fi
done

folder_path=$1

# Call psql with the SQL file and pass parameters correctly
echo "Searching for users..."
psql -d "$DATABASE_NAME" -v date="'$date'" -f "$folder_path/user_post_after_date_search_tool.sql"

# Success message
echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
