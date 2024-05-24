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
echo -e "${GREEN}Welcome to the Average Movie Duration by City Tool${NC}"
echo "This tool allows you to find the average duration of movies projected in cities hosting long movies or events."

# New line
echo

# Description of the task
echo -e "${YELLOW}Task: Find cities that host at least one event or project at least one movie longer than 1h30.${NC}"
echo "The query will calculate and display the average duration of movies projected in these cities."

# New line
echo

# Set the database name
DATABASE_NAME="cinenetdb"

# Check if folder_path and choice are provided
if [ -z "$folder_path" ] || [ -z "$choice" ]; then
  echo -e "${RED}Error: Missing required parameters.${NC}"
  echo "Usage: $0 /path/to/sql/files choice"
  exit 1
fi

# Verify if the SQL file exists
if [ ! -f "$folder_path/$sql_file" ]; then
  echo -e "${RED}Error: SQL file not found: $folder_path/$sql_file${NC}"
  exit 1
fi

# Call psql with the SQL file and pass parameters correctly
echo "Calculating the average duration of movies projected in the specified cities..."
psql -d "$DATABASE_NAME" -f "$folder_path/$sql_file"

# Success message
echo -e "${GREEN}Calculation completed. Check the output above for results.${NC}"
