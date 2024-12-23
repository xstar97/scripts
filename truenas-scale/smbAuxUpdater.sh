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

# Function to fetch a list of SMB shares
display_shares() {
    midclt call sharing.smb.query | jq -r \
        '.[] | "\(.id).\n  PATH: \(.path)\n  NAME: \(.name)\n  AUXSMBCONF: \(.auxsmbconf | select(. != "") // "None")\n"'
}

# Parse command-line flags
while [[ $# -gt 0 ]]; do
    case $1 in
        --list)
            display_shares
            exit 0
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

# If an ID is provided, update the corresponding SMB share
if [[ -n "$choice" ]]; then
    update_auxsmbconf "$choice" "$auxsmbconfuser"
else
    # Interactive prompt if no ID is provided
    while true; do
        display_shares
        read -p "Enter the ID of the SMB share to update or 'q' to quit: " choice
        if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
            echo "Exiting..."
            exit 0
        elif [[ "$choice" =~ ^[0-9]+$ ]]; then
            update_auxsmbconf "$choice" "$auxsmbconfuser"
        else
            echo "Invalid input. Please enter a valid numeric ID or 'q' to quit."
        fi
    done
fi
