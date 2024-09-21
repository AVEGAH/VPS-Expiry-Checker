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
        // Assuming the expiry date is in a specific position in your database format
        // Replace the below line with the actual way to extract the expiry date
        // For example, let's assume the expiry date is the second field
        $fields = explode(' ', trim($user_details));
        return isset($fields[1]) ? $fields[1] : 'Expiry date not found.';
    } else {
        return 'User not found.';
    }
}

// Output the result
$expiry_date = getExpiryDate($username, $database);
echo "Expiry Date for user $username: $expiry_date";
?>
