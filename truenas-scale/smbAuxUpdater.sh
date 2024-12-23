#!/bin/bash

# Default variable for auxiliary SMB configuration
auxsmbconfuser="force user = apps\nforce group = apps"

# Function to update auxsmbconf for a specific SMB share
update_auxsmbconf() {
    local id=$1
    local conf=$2
    echo "Updating auxsmbconf for ID: $id..."
    midclt call sharing.smb.update "$id" "{\"auxsmbconf\": \"$conf\"}"
}

# Function to fetch and display a list of SMB shares
display_shares() {
    midclt call sharing.smb.query | jq -r \
        '.[] | "\(.id).\n  PATH: \(.path)\n  NAME: \(.name)\n  AUXSMBCONF: \(.auxsmbconf | select(. != "") // "None")\n"'
}

# Parse command-line flags
interactive_mode=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --list)
            display_shares
            exit 0
            ;;
        --inter)
            interactive_mode=true
            shift
            ;;
        --id)
            choice="$2"
            shift 2
            ;;
        --user)
            if [[ -n "$2" ]]; then
                auxsmbconfuser="force user = $2\nforce group = $2"
                shift 2
            else
                echo "Error: --user requires a user/group value."
                exit 1
            fi
            ;;
        --remove-aux)
            remove_aux=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Default behavior: always show the list of SMB shares
display_shares

# If --inter flag is used, allow user interaction to select SMB share to update
if [[ "$interactive_mode" == true ]]; then
    while true; do
        read -p "Enter the ID of the SMB share to update or 'q' to quit: " choice
        if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
            echo "Exiting..."
            exit 0
        elif [[ "$choice" =~ ^[0-9]+$ ]]; then
            if [[ -n "$choice" ]]; then
                if [[ "$remove_aux" == true ]]; then
                    update_auxsmbconf "$choice" ""
                else
                    update_auxsmbconf "$choice" "$auxsmbconfuser"
                fi
            fi
        else
            echo "Invalid input. Please enter a valid numeric ID or 'q' to quit."
        fi
    done
fi
