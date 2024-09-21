#!/bin/bash

# Database file containing user information
database="/root/usuarios.db"

# Function to check user expiry
check_expiry() {
    user="$1"
    expiry_date=$(grep "^$user:" /etc/shadow | cut -d: -f8)  # Assuming the expiry date is in field 8
    current_date=$(date +%s)
    
    if [ -z "$expiry_date" ]; then
        echo "User $user does not have an expiry date."
        return
    fi

    expiry_timestamp=$(date -d "$expiry_date" +%s)
    days_left=$(( (expiry_timestamp - current_date) / 86400 ))  # Convert seconds to days

    if [ "$days_left" -lt 0 ]; then
        echo "$user has expired."
    else
        echo "$user's account expires in $days_left days."
    fi
}

# Main processing
if [[ -n "$1" ]]; then
    username="$1"
    check_expiry "$username"
else
    echo "No username provided. Please provide a username as an argument."
fi
