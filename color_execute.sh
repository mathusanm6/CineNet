#!/bin/bash

# Function to create a PostgreSQL database if it does not exist
function create_database_if_not_exists() {
    local dbname="$1"  # Name of the database to check and potentially create

    # Check if the database exists
    if ! psql -lqt | cut -d \| -f 1 | grep -qw "$dbname"; then
        echo -e "\033[1;33mCreating database $dbname\033[0m"
        createdb "$dbname"
    else
        echo -e "\033[1;34mDatabase $dbname already exists\033[0m"
    fi
}

# Function to get color codes
function get_color_code() {
    case "$1" in
    "yellow")
        echo "\033[1;33m"
        ;;
    "green")
        echo "\033[1;32m"
        ;;
    "red")
        echo "\033[1;31m"
        ;;
    "blue")
        echo "\033[1;34m"
        ;;
    *)
        echo "\033[0m" # Default color
        ;;
    esac
}

# Function to execute SQL scripts with color-coded output
function execute_sql_script() {
    local script_name="$1"
    local dbname="$2"
    local show_output="$3"

    # Fetch the color code
    local color_reset="\033[0m"
    local color_red="\033[1;31m"
    local color_green="\033[1;32m"

    # Create database if it does not exist
    create_database_if_not_exists "$dbname"

    # Execute the SQL script
    if [[ "$show_output" == "yes" ]]; then
        psql -d "$dbname" -f "$script_name.sql"
    else
        psql -d "$dbname" -f "$script_name.sql" > /dev/null 2>&1
    fi

    # Check the exit status of the psql command
    if [[ "$?" -eq 0 ]]; then
        echo -e "${color_green}Script $script_name.sql executed successfully${color_reset}"
    else
        echo -e "${color_red}Error executing script $script_name.sql${color_reset}"
    fi
}
