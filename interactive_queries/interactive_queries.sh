#!/bin/bash

# Function to clear the terminal screen
clear_screen() {
    echo -e "\033[2J\033[1;1H"
}

# Function to get color codes
get_color_code() {
    case $1 in
    "green")
        echo -e "\033[1;32m"
        ;;
    "red")
        echo -e "\033[1;31m"
        ;;
    "yellow")
        echo -e "\033[1;33m"
        ;;
    "blue")
        echo -e "\033[1;34m"
        ;;
    "reset")
        echo -e "\033[0m"
        ;;
    esac
}

# Check and set executable permissions for scripts
ensure_executable() {
    local script_path=$1
    if [[ ! -x "$script_path" ]]; then
        echo -e "$(get_color_code "yellow")Making $script_path executable$(get_color_code "reset")"
        chmod +x "$script_path"
    fi
}

# Run selected script
run_script() {
    local choice=$1
    local super_folder_path=$2
    local script_name="script_$choice.sh"
    local script_path="$super_folder_path/query_files/$choice/$script_name"
    ensure_executable "$script_path"
    echo -e "$(get_color_code "blue")Running $script_name...$(get_color_code "reset")"
    bash "$script_path" "$super_folder_path/query_files/$choice/" "$choice"
}

# Variables for pagination
declare -a pages=("1" "2" "3")
declare -a page_title=("Page 1" "Page 2" "Page 3")
current_page=1

# Display menu with pagination
display_menu() {
    clear_screen
    echo -e "$(get_color_code "green")Page $current_page: ${page_title[$((current_page - 1))]} - Please select a script to run:$(get_color_code "reset")"

    case $current_page in
    1)
        echo -e "$(get_color_code "blue")1) Event Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for users who are participating in an scheduled event in a specific country. (at least three tables query)"

        echo -e "$(get_color_code "blue")2) Follower Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for users who follow a specific user. (auto-join query)"

        echo -e "$(get_color_code "blue")3) At Least Following Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for users who follow at least a specific number of users. (correlated subquery)"

        echo -e "$(get_color_code "blue")4) Average Popularity Score Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to find the average popularity score of all users. (subquery in FROM)"
        ;;
    2)
        echo -e "$(get_color_code "blue")5) User Post After Date Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for users who posted after a specific date. (subquery in WHERE)"

        echo -e "$(get_color_code "blue")6) At Least User Count Per Country Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for countries with at least a specific number of users. (aggregation with GROUP BY and HAVING)"

        echo -e "$(get_color_code "blue")7) At Least Post Count Specified Reaction Having Tag Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for tags with at least a specific number of posts with a specified reaction."
        echo -e "   (aggregation with GROUP BY and HAVING)"

        echo -e "$(get_color_code "blue")8) Average Maximum Number of Reactions Per Post Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to find the average maximum number of reactions per post."
        echo -e "   (two aggregates calculation)"
        ;;
    3)
        echo -e "$(get_color_code "blue")9) User Participation Event With Status List Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to list all users who have participated in an event with a specific status."
        echo -e "   (an outer join query - LEFT JOIN)"
        ;;
    esac

    echo
    [[ $current_page -gt 1 ]] && echo -e "$(get_color_code "yellow")P) Previous Page$(get_color_code "reset")"
    [[ $current_page -lt ${#pages[@]} ]] && echo -e "$(get_color_code "yellow")N) Next Page$(get_color_code "reset")"
    echo -e "$(get_color_code "red")Q) Quit$(get_color_code "reset")"
}

# Main function
main() {
    local cont="y"
    while [[ $cont =~ ^[Yy]$ ]]; do
        display_menu
        read -p "$(get_color_code "yellow")Enter your choice (number, P/N for page navigation, Q to quit): $(get_color_code "reset")" choice
        clear_screen

        case $choice in
        [1-9])
            run_script "$choice" "$super_folder_path"

            echo

            read -p "$(get_color_code "blue")Do you want to run another script? (y/n): $(get_color_code "reset")" cont
            [[ -z "$cont" ]] && cont="y" # Default to 'Yes' if no input
            clear_screen
            ;;
        P | p)
            [[ $current_page -gt 1 ]] && ((current_page--))
            ;;
        N | n)
            [[ $current_page -lt ${#pages[@]} ]] && ((current_page++))
            ;;
        [Qq])
            echo -e "$(get_color_code "green")Exiting...$(get_color_code "reset")"
            exit 0
            ;;
        *)
            echo -e "$(get_color_code "red")Invalid choice. Please try again.$(get_color_code "reset")"
            ;;
        esac
    done
}

# Global variables for folder paths
super_folder_path=$1

# Run the main function
main
