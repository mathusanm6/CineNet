#!/bin/bash

# Function to clear the terminal screen
clear_screen() {
    echo -e "\033[2J\033[1;1H"
}

# Function to add new line
add_new_line() {
    echo
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
declare -a pages=("1" "2" "3" "4" "5")
current_page=1

# Display menu with pagination
display_menu() {
    clear_screen
    echo -e "$(get_color_code "green")Page $current_page: - Please select a script to run:$(get_color_code "reset")"

    case $current_page in
    1)
        echo -e "$(get_color_code "blue")1)  Event Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to search for users who are participating in an scheduled event in a specific country. (at least three tables query)"

        add_new_line

        echo -e "$(get_color_code "blue")2)  Follower Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to search for users who follow a specific user. (auto-join query)"

        add_new_line

        echo -e "$(get_color_code "blue")3)  At Least Following Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to search for users who follow at least a specific number of users. (correlated subquery)"

        add_new_line

        echo -e "$(get_color_code "blue")4)  Average Popularity Score Per Country Finder$(get_color_code "reset")"
        echo -e "    This tool allows you to find the average popularity score of all users per country. (subquery in FROM)"

        add_new_line

        echo -e "$(get_color_code "blue")5)  User Post After Date Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to search for users who posted after a specific date. (subquery in WHERE)"
        ;;
    2)
        echo -e "$(get_color_code "blue")6) At Least User Count Per Country Search Tool$(get_color_code "reset")"
        echo -e "   This tool allows you to search for countries with at least a specific number of users. (aggregation with GROUP BY and HAVING)"

        add_new_line

        echo -e "$(get_color_code "blue")7)  At Least Post Count Specified Reaction Having Tag Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to search for tags with at least a specific number of posts with a specified reaction."
        echo -e "    (aggregation with GROUP BY and HAVING)"

        add_new_line

        echo -e "$(get_color_code "blue")8)  Average Maximum Number of Reactions Per Post Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to find the average maximum number of reactions per post."
        echo -e "    (two aggregates calculation)"

        add_new_line

        echo -e "$(get_color_code "blue")9)  User Participation Event With Status List Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to list all users who have expressed interest or are participating in an event with a specific status."
        echo -e "    (an outer join query - LEFT JOIN)"
        ;;
    3)
        echo -e "$(get_color_code "blue")10) User Reacting to Every Single Post of a Given User Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to list all users who reacted to every single post of a given user."
        echo -e "    (two equivalent queries with correlated subqueries)"

        add_new_line

        echo -e "$(get_color_code "blue")11) User Reacting to Every Single Post of a Given User Search Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to list all users who reacted to every single post of a given user."
        echo -e "    (two equivalent queries with aggregation)"

        add_new_line

        echo -e "$(get_color_code "blue")12) Posts Not Having Any Subposts Listing Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to find all posts that do not have any subposts."
        echo -e "    (EXCEPT : Right Results)"

        add_new_line

        echo -e "$(get_color_code "blue")13) Posts Not Having Any Subposts Listing Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to find all posts that do not have any subposts."
        echo -e "    (NOT EXISTS : Right Results)"

        ;;
    4)

        echo -e "$(get_color_code "blue")14) Posts Not Having Any Subposts Listing Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to find all posts that do not have any subposts."
        echo -e "    (NOT IN : Wrong Results)"
        
        add_new_line

        echo -e "$(get_color_code "blue")15) Upcoming Scheduled Event Finding Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to find the earliest upcoming scheduled event."
        echo -e "    (recursive query)"

        add_new_line

        echo -e "$(get_color_code "blue")16) Top 10 Popular Events Finder$(get_color_code "reset")"
        echo -e "    This tool allows you to find the top 10 popular events."
        echo -e "    (windowing)"

        ;;

    5)
        echo -e "$(get_color_code "blue")17) User Posts Counting Tool$(get_color_code "reset")"
        echo -e "    This tool allows you to find the number of posts made by each user."

        add_new_line

        echo -e "$(get_color_code "blue")18) Sub-Genre Finder$(get_color_code "reset")"
        echo -e "    This tool allows you to find all sub-genres of a specified parent genre."

        add_new_line

        echo -e "$(get_color_code "blue")19) Cities Hosting Events or Projecting Movies Longer Than 1h30 Finder$(get_color_code "reset")"
        echo -e "    This tool allows you to find the cities that host at least one event with at least one movie longer than 1h30."
        
        add_new_line

        echo -e "$(get_color_code "blue")20) Future Events With More Than 10 Participants Per Month Finder$(get_color_code "reset")"
        echo -e "    This tool allows you to find the future events with more than 10 participants per month."

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
        1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20)
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
