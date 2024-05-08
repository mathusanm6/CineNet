#!/bin/bash

# Source the function definitions
source scripts/color_execute.sh

show_output="$1"
super_folder="$2"

# Call the function with color and script name
execute_sql_script "movie_recommendation" "cinenetdb" "$show_output" "$super_folder"
execute_sql_script "completed_event_recommendation" "cinenetdb" "$show_output" "$super_folder"
execute_sql_script "post_recommendation" "cinenetdb" "$show_output" "$super_folder"
execute_sql_script "scheduled_event_recommendation" "cinenetdb" "$show_output" "$super_folder"
