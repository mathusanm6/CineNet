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
echo -e "${GREEN}Welcome to the User Posts Counting Tool${NC}"
echo "This tool allows you to find the number of posts made by each user."

# New line
echo

# Answer for the question (french)
echo -e "${YELLOW}Question: Écrivez une requête pour compter le nombre de publications par utilisateur${NC}"
echo

# Set the database name
DATABASE_NAME="cinenetdb"

# Call psql with the SQL file and pass parameters correctly
echo "Counting the number of posts made by each user..."
psql -d "$DATABASE_NAME" -f "$folder_path/$sql_file"

# Success message
echo -e "${GREEN}Count completed. Check the output above for results.${NC}"
