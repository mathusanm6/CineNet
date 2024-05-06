#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Welcome message
echo -e "${GREEN}Welcome to the Average Popularity Score Tool${NC}"
echo "This tool allows you to find the average popularity score of all users."

# New line
echo

# Answer for the question (french)
echo -e "${YELLOW}Question: Écrivez une une sous-requête dans le FROM${NC}"

echo

# Set the database name
DATABASE_NAME="cinenetdb"

# Call psql with the SQL file and pass parameters correctly
echo "Searching for average popularity score..."
psql -d "$DATABASE_NAME" -f average_popularity_score_tool.sql

# Success message
echo -e "${GREEN}Search completed. Check the output above for results.${NC}"
