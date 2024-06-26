#!/bin/bash

# Source the color execution functions
source scripts/color_execute.sh

function clear_terminal() {
    # Clear the right side of the terminal to ensure the output is clean
    echo -e "\033[2J\033[1;1H" # Clear the screen and move the cursor to 1,1 position
}

# Function to run generate_data.py
function run_generate_csv() {
    echo -e "$(get_color_code "yellow")Running generate_csv.py$(get_color_code "reset")"
    source cinenet_env/bin/activate
    python3 scripts/generate/generate_csv.py
}

# Function to run create_db.sh
function run_create_db() {
    local show_output="$1"
    local script_name="scripts/create/create_db.sh"

    echo -e "$(get_color_code "yellow")Running create_db.sh$(get_color_code "reset")"
    chmod +x $script_name
    bash $script_name "$show_output" "scripts/create"
}

# Function to run import_data.sh
function run_import_data() {
    local show_output="$1"
    local script_name="scripts/import/import_data.sh"

    echo -e "$(get_color_code "yellow")Running import_data.sh$(get_color_code "reset")"
    chmod +x $script_name
    bash $script_name "$show_output" "scripts/import"
}

# Function to execute init_recommendation SQL script
function run_init_recommendation() {
    local show_output="$1"
    local script_name="scripts/recommendation/init_recommendation.sh"

    echo -e "$(get_color_code "yellow")Running init_recommendation.sh$(get_color_code "reset")"
    chmod +x $script_name
    bash $script_name "$show_output" "scripts/recommendation"
}

# Function to run interactive queries
function run_interactive_queries() {
    local script_name="scripts/interactive_queries/interactive_queries.sh"

    echo -e "$(get_color_code "blue")Running interactive_queries.sh$(get_color_code "reset")"
    chmod +x $script_name
    bash $script_name "scripts/interactive_queries"
}

function print_usage() {
    # Define color codes
    local color_reset="\033[0m"
    local color_command="\033[1;34m" # Blue for commands
    local color_options="\033[1;32m" # Green for options
    local color_example="\033[1;33m" # Yellow for examples

    echo -e "${color_command}Usage:${color_reset} $0 [option] [show_output]"
    echo -e "Where [option] can be:"
    echo -e "  ${color_options}1${color_reset} - To run only ${color_command}create_db.sh${color_reset}"
    echo -e "  ${color_options}2${color_reset} - To run only ${color_command}generate_csv.py${color_reset}"
    echo -e "  ${color_options}3${color_reset} - To run only ${color_command}import_data.sh${color_reset}"
    echo -e "  ${color_options}4${color_reset} - To run only ${color_command}init_recommendation.sh${color_reset}"
    echo -e "  ${color_options}all${color_reset} - To run ${color_command}create_db.sh${color_reset}, ${color_command}generate_csv.py${color_reset}, and then execute ${color_command}import_data.sh${color_reset}"
    echo -e "  ${color_options}interactive${color_reset} - To run the interactive_queries.sh script"
    echo -e "${color_example}Examples:${color_reset} $0 1 yes - Just creates the database and show PostgreSQL output"
    echo -e "          $0 2 no - Only runs generate_csv.py and do not show PostgreSQL output"
    echo -e "          $0 3 yes - Only runs import_data.sh and show PostgreSQL output"
    echo -e "          $0 4 no - Only runs init_recommendation.sh and do not show PostgreSQL output"
    echo -e "          $0 all yes - Runs all scripts except ${color_command}init_recommendation.sh${color_reset} in sequence and show PostgreSQL output"
    echo -e "          $0 interactive - Runs in interactive mode"
}

# Check for 'interactive' mode with exactly one argument
if [[ "$1" == "interactive" ]]; then
    if [[ "$#" -ne 1 ]]; then
        echo "Error: Interactive mode does not require any arguments."
        print_usage
        exit 1
    fi
    echo "Running in interactive mode..."
else
    if [[ "$#" -ne 2 ]]; then
        echo "Error: Invalid number of arguments."
        print_usage
        exit 1
    fi
fi

show_output="$2"

case "$1" in
1)
    clear_terminal
    run_create_db "$show_output"
    ;;
2)
    clear_terminal
    run_generate_csv
    ;;
3)
    clear_terminal
    run_import_data "$show_output"
    ;;
4)
    clear_terminal
    run_init_recommendation "$show_output"
    ;;
all)
    clear_terminal
    run_create_db "$show_output"
    run_generate_csv
    run_import_data "$show_output"
    ;;
interactive)
    clear_terminal
    run_interactive_queries
    ;;
*)
    echo "Invalid option: $1"
    print_usage
    exit 1
    ;;
esac
