#!/bin/bash

# Function to execute SQL scripts with color-coded output
function execute_sql_script() {
    local color_code="$1"
    local script_name="$2"

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

    # Fetch the color code
    local color=$(get_color_code $color_code)

    # Echoing the starting execution message with color
    echo -e "${color}Executing $script_name.sql\033[0m"
    
    # Execute the SQL script
    psql -d postgres -f "$script_name.sql"
}

