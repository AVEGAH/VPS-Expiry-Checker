#!/bin/bash

# Location of user files
USER_DIR="/etc/VPSManager/senha/"

# Get username from query parameter (?username=maptech)
USERNAME=$(echo "$QUERY_STRING" | sed -n 's/^.*username=[^&]*.*$/\1/p')

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

# Extract the expiry date from the user file (assuming expiry date is in the file)
# Modify this line if the expiry date format is different or stored in a different way.
EXPIRY_DATE=$(grep -i 'expiry_date' "$USER_FILE" | cut -d':' -f2)

# Check if expiry date was found
if [ -z "$EXPIRY_DATE" ]; then
    echo "Content-type: text/html"
    echo ""
    echo "<html><body>"
    echo "<h3>Error: Expiry date not found for $USERNAME</h3>"
    echo "</body></html>"
    exit 1
fi

# Calculate days left
CURRENT_DATE=$(date +%Y-%m-%d)
DAYS_LEFT=$(( ( $(date -d "$EXPIRY_DATE" +%s) - $(date -d "$CURRENT_DATE" +%s) ) / 86400 ))

# Output HTML page with user info
echo "Content-type: text/html"
echo ""
echo "<html><body>"
echo "<h3>🌍 MAPTECH VPS MANAGER 🌍</h3>"
echo "<p>Username: $USERNAME</p>"
echo "<p>Expiry Date: $EXPIRY_DATE</p>"

if [ "$DAYS_LEFT" -lt 0 ]; then
    echo "<p>Status: Expired</p>"
else
    echo "<p>Days Left: $DAYS_LEFT days</p>"
fi

echo "</body></html>"