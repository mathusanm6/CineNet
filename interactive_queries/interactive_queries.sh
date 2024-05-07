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
    local script_name=$1
    local folder_path=$2
    local super_folder_path=$3
    local script_path="$super_folder_path/query_files/$folder_path/$script_name"
    ensure_executable "$script_path"
    echo -e "$(get_color_code "blue")Running $script_name...$(get_color_code "reset")"
    bash "$script_path" "$super_folder_path/query_files/$folder_path"
}

# Display menu
display_menu() {
    clear_screen
    echo -e "$(get_color_code "green")Please select a script to run:$(get_color_code "reset")"
    
    echo -e "$(get_color_code "blue")1) Event Search Tool$(get_color_code "reset")"
    echo -e "   This tool allows you to search for users who are participating in an scheduled event in a specific country. (at least three tables query)"
    
    echo -e "$(get_color_code "blue")2) Follower Search Tool$(get_color_code "reset")"
    echo -e "   This tool allows you to search for users who follow a specific user. (auto-join query)"
    
    echo -e "$(get_color_code "blue")3) At Least Following Search Tool$(get_color_code "reset")"
    echo -e "   This tool allows you to search for users who follow at least a specific number of users. (correlated subquery)"
    
    echo -e "$(get_color_code "blue")4) Average Popularity Score Tool$(get_color_code "reset")"
    echo -e "   This tool allows you to find the average popularity score of all users. (subquery in FROM)"
    
    echo -e "$(get_color_code "blue")5) User Post After Date Search Tool$(get_color_code "reset")"
    echo -e "   This tool allows you to search for users who posted after a specific date. (subquery in WHERE)"
    
    echo -e "$(get_color_code "red")Q) Quit$(get_color_code "reset")"
}

super_folder_path=$1

# Main function
main() {
    local cont="y"
    while [[ $cont =~ ^[Yy]$ ]]; do
        display_menu
        read -p "$(get_color_code "yellow")Enter your choice (1-5, Q): $(get_color_code "reset")" choice
        clear_screen
        case $choice in
        1)
            run_script "event_search_tool.sh" "1" "$super_folder_path"
            ;;
        2)
            run_script "follower_search_tool.sh" "2" "$super_folder_path"
            ;;
        3)
            run_script "at_least_following_search_tool.sh" "3" "$super_folder_path"
            ;;
        4)
            run_script "average_popularity_score_tool.sh" "4" "$super_folder_path"
            ;;
        5)
            run_script "user_post_after_date_search_tool.sh" "5" "$super_folder_path"
            ;;
        [Qq])
            echo -e "$(get_color_code "green")Exiting...$(get_color_code "reset")"
            exit 0
            ;;
        *)
            echo -e "$(get_color_code "red")Invalid choice. Please select a number between 1-5 or Q to quit.$(get_color_code "reset")"
            ;;
        esac

        echo 
        
        read -p "$(get_color_code "blue")Do you want to run another script? (y/n): $(get_color_code "reset")" cont
        [[ -z "$cont" ]] && cont="y" # Default to 'Yes' if no input
        clear_screen
    done
}

# Run the main function
main
