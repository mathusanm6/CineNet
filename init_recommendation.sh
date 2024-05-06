#!/bin/bash

# Source the function definitions
source color_execute.sh

# Call the function with color and script name
execute_sql_script "yellow" "init_recommendation"
execute_sql_script "green" "movie_recommendation"
execute_sql_script "green" "completed_event_recommendation"
execute_sql_script "green" "post_recommendation"
execute_sql_script "green" "scheduled_event_recommendation"