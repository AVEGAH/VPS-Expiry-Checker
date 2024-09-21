#!/bin/bash

# Location of user files
USER_DIR="/etc/VPSManager/senha/"

# Get username from query parameter (?username=maptech)
USERNAME=$(echo "$QUERY_STRING" | sed -n 's/^.*username=\([^&]*\).*$/\1/p')

# Check if username is provided
if [ -z "$USERNAME" ]; then
    echo "Content-type: text/html"
    echo ""
    echo "<html><body>"
    echo "<h3>Error: No username provided</h3>"
    echo "</body></html>"
    exit 1
fi

# Find the user file that matches the username
USER_FILE=$(find "$USER_DIR" -type f -name "$USERNAME")

# Check if the user file exists
if [ -z "$USER_FILE" ]; then
    echo "Content-type: text/html"
    echo ""
    echo "<html><body>"
    echo "<h3>Error: User not found</h3>"
    echo "</body></html>"
    exit 1
fi

# Add code here to check expiry date and output the result

# Example output (you should replace this with your actual expiry check logic)
echo "Content-type: text/html"
echo ""
echo "<html><body>"
echo "<h3>User: $USERNAME</h3>"
echo "<p>Expiry Date: [expiry date here]</p>"
echo "</body></html>"
