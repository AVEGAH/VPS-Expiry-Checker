#!/bin/bash

# Update package index
sudo apt update

# Install Apache and PHP
sudo apt install -y apache2 php libapache2-mod-php

# Create directory for the PHP script if it doesn't exist
sudo mkdir -p /var/www/html/server

# Download the user expiry script
cat << 'EOF' | sudo tee /var/www/html/server/expiry.php
<?php
// Database path
$database = '/root/usuarios.db';

// Get username from query parameter
$username = isset($_GET['user']) ? $_GET['user'] : '';

// Function to get expiry date
function getExpiryDate($username, $database) {
    // Fetch user details from the database
    $user_details = shell_exec("grep '^$username ' $database");
    if ($user_details) {
        // Extract the expiry value (the second field)
        $fields = explode(' ', trim($user_details));
        $expiry_value = isset($fields[1]) ? (int)$fields[1] : null;

        // Format the output based on expiry value
        if ($expiry_value !== null) {
            return "$username $expiry_value day" . ($expiry_value > 1 ? "s" : "") . " left";
        }
    }
    return 'User not found.';
}

// Output the result
$expiry_date = getExpiryDate($username, $database);
echo "Expiry Date for user $username: " . $expiry_date;
EOF

# Set appropriate permissions for the PHP script
sudo chown www-data:www-data /var/www/html/server/expiry.php
sudo chmod 644 /var/www/html/server/expiry.php

# Set permissions for the existing database file
sudo chown www-data:www-data /root/usuarios.db
sudo chmod 644 /root/usuarios.db

# Restart Apache
sudo systemctl restart apache2

# Get the VPS IP address
VPS_IP=$(hostname -I | awk '{print $1}')

echo "Setup complete! You can access the script at http://$VPS_IP:8888/server/expiry.php?user=username"
