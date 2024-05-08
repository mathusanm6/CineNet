#!/bin/bash

# Source the function definitions
source scripts/color_execute.sh

show_output="$1"
super_folder="$2"

# Call the function with color and script name
execute_sql_script "create_db" "cinenetdb" "$show_output" "$super_folder"
