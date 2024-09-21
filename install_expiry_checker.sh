#!/bin/bash

# Update package index
sudo apt update

# Install Apache and PHP
sudo apt install -y apache2 php libapache2-mod-php

# Configure Apache to listen on port 8888
echo "Listen 8888" | sudo tee -a /etc/apache2/ports.conf

# Configure the default site to use port 8888
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8888>/' /etc/apache2/sites-available/000-default.conf

# Create directory for the PHP script
sudo mkdir -p /var/www/html/server

# Download the user expiry script
wget -O /var/www/html/server/expiry.php https://raw.githubusercontent.com/AVEGAH/VPS-Expiry-Checker/refs/heads/main/user_expiry.php

# Set appropriate permissions
sudo chown www-data:www-data /var/www/html/server/expiry.php
sudo chmod 644 /var/www/html/server/expiry.php

# Restart Apache
sudo systemctl restart apache2

echo "Setup complete! You can access the script at http://YOUR_VPS_IP:8888/server/expiry.php?user=username"
