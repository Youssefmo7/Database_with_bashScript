#!/bin/bash

# DATABASE MANAGEMENT SYSTEM - Main Script

# Load common functions and variables
source ./common.sh

# Create the databases folder if missing

if [ ! -d "$DATABASE_DIR" ]
then
    mkdir "$DATABASE_DIR"
fi


show_menu() {
    echo ""
    echo "========================================"
    echo "     DATABASE MANAGEMENT SYSTEM"
    echo "========================================"
    echo ""
    echo "  1. Create Database"
    echo "  2. List Databases"
    echo "  3. Connect to Database"
    echo "  4. Delete Database"
    echo "  5. Exit"
    echo ""
    echo "========================================"
}


while true
do
    show_menu
    
    echo -n "Enter your choice [1-5]: "
    read choice
    
    case $choice in
        1)
            bash ./db_functions/create_db.sh
            ;;
        2)
            bash ./db_functions/list_db.sh
            ;;
        3)
            bash ./db_functions/connect_db.sh
            ;;
        4)
            bash ./db_functions/delete_db.sh
            ;;
        5)
            echo ""
            echo "Goodbye!"
            echo ""
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1-5."
            ;;
    esac
    
    # Pause before showing menu again
    echo ""
    echo "Press Enter to continue..."
    read
done