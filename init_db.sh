#!/bin/bash

# Source the function definitions
source color_execute.sh

# Call the function with color and script name
execute_sql_script "red" "create_db"
execute_sql_script "blue" "import_data"