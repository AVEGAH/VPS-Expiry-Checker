#!/bin/bash

# Update package index
sudo apt update

# Install Apache and PHP
sudo apt install -y apache2 php libapache2-mod-php

# Create directory for the PHP script if it doesn't exist
sudo mkdir -p /var/www/html/server

# Download the user expiry script
wget -O /var/www/html/server/expiry.php https://raw.githubusercontent.com/AVEGAH/VPS-Expiry-Checker/refs/heads/main/user_expiry.php

# Set appropriate permissions for the PHP script
sudo chown www-data:www-data /var/www/html/server/expiry.php
sudo chmod 644 /var/www/html/server/expiry.php

# Set permissions for the existing database file (make sure to adjust the path if needed)
sudo chown www-data:www-data /root/usuarios.db
sudo chmod 644 /root/usuarios.db

# Restart Apache
sudo systemctl restart apache2

# Get the VPS IP address
VPS_IP=$(hostname -I | awk '{print $1}')

echo "Setup complete! You can access the script at http://$VPS_IP:8888/server/expiry.php?user=username"
