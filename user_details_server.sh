#!/bin/bash

# Variables
VPS_IP="104.248.128.202"          # Replace with your VPS IP
PORT="8888"                   # Choose an appropriate port
DATABASE="/root/usuarios.db"  # Path to your user database

# Function to get user details
get_user_details() {
    local username="$1"
    if [[ -z "$username" ]]; then
        echo "No username provided."
        return 1
    fi

    # Fetch user details from the database
    user_details=$(grep "^$username " "$DATABASE")
    if [[ -z "$user_details" ]]; then
        echo "User not found."
    else
        echo "$user_details"
    fi
}

# Start a simple HTTP server
start_server() {
    echo "Starting server on $VPS_IP:$PORT..."
    while true; do
        {
            # Read the request
            read request
            read request # Read the second line for POST data (if needed)
            if [[ "$request" =~ GET\ /\?user\=([a-zA-Z0-9_]+) ]]; then
                username="${BASH_REMATCH[1]}"
                user_info=$(get_user_details "$username")
                if [[ -z "$user_info" ]]; then
                    response="HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nUser not found."
                else
                    response="HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n$user_info"
                fi
            else
                response="HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain\r\n\r\nInvalid request."
            fi
            echo -e "$response"
        } | nc -l -p "$PORT" -q 1
    done
}

# Main execution
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

start_server
