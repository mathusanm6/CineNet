#!/bin/bash

# Source the function definitions
source color_execute.sh

show_output="$1"

# Call the function with color and script name
execute_sql_script "movie_recommendation" "cinenetdb" "$show_output"
execute_sql_script "completed_event_recommendation" "cinenetdb" "$show_output"
execute_sql_script "post_recommendation" "cinenetdb" "$show_output"
execute_sql_script "scheduled_event_recommendation" "cinenetdb" "$show_output"
