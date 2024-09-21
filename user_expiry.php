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
        return isset($fields[1]) ? $fields[1] : 'Expiry date not found.';
    } else {
        return 'User not found.';
    }
}

// Output the result
$expiry_date = getExpiryDate($username, $database);
echo "Expiry Date for user $username: $expiry_date";
?>
