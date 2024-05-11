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

# Welcome message
echo -e "${GREEN}Welcome to the Posts Not Having Any Subposts Listing Tool${NC}"
echo "This tool allows you to find all posts that do not have any subposts."

# New line
echo

# Answer for the question (french)
echo -e "${YELLOW}Question: Écrivez deux requêtes qui renverraients le même résultat si vos tables ne contenaient pas de valeurs NULL${NC}"
echo
echo -e "${RED}NOT EXISTS : Right Results${NC}"
echo

# Set the database name
DATABASE_NAME="cinenetdb"

# Call psql with the SQL file and pass parameters correctly
echo "Searching for posts not having any subposts..."

# Run the SQL script
read -s -p "Press enter to continue"

psql -d "$DATABASE_NAME" -f "$folder_path/$sql_file"

# Success message
echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
