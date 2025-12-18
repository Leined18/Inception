<?php
/**
 * WordPress base configuration using Docker secrets and environment variables
 * for database credentials and admin/user passwords.
 *
 * @package WordPress
 */

/**
 * Retrieve a secret from file or fallback to an environment variable
 *
 * @param string $env_var Environment variable name
 * @param string $file_path Path to secret file (from mounted volume)
 * @return string
 */
function get_secret($env_var, $file_path) {
    $val = getenv($env_var);
    if ($val !== false && $val !== '') {
        return $val;
    }

    if ($file_path && file_exists($file_path)) {
        return trim(file_get_contents($file_path));
    }

    error_log("Secret or environment variable not found: $env_var / $file_path");
    return '';
}

// -----------------
// Database settings
// -----------------
define('DB_NAME', getenv('DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('DB_USER') ?: 'wordpress');
define('DB_PASSWORD', get_secret('DB_PASSWORD', '/run/secrets/db_user_password'));
define('DB_HOST', getenv('DB_HOST') ?: 'db:3306');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// -----------------
// Authentication keys and salts
// -----------------
define('AUTH_KEY',         'put-your-unique-phrase-here');
define('SECURE_AUTH_KEY',  'put-your-unique-phrase-here');
define('LOGGED_IN_KEY',    'put-your-unique-phrase-here');
define('NONCE_KEY',        'put-your-unique-phrase-here');
define('AUTH_SALT',        'put-your-unique-phrase-here');
define('SECURE_AUTH_SALT', 'put-your-unique-phrase-here');
define('LOGGED_IN_SALT',   'put-your-unique-phrase-here');
define('NONCE_SALT',       'put-your-unique-phrase-here');

// -----------------
// Debugging & caching
// -----------------
define('WP_DEBUG', true);
define('WP_ALLOW_REPAIR', true);
define('WP_REDIS_HOST', getenv('WP_REDIS_HOST') ?: 'redis');
define('WP_REDIS_PORT', getenv('WP_REDIS_PORT') ?: 6379);
define('WP_CACHE', true);

// -----------------
// Filesystem
// -----------------
define('FS_METHOD', 'direct');
define('FS_CHMOD_FILE', 0644);
define('FS_CHMOD_DIR', 0755);

// -----------------
// Table prefix
// -----------------
$table_prefix = 'wp_';

// -----------------
// Admin & normal user credentials from secrets
// -----------------
define('WP_ADMIN_USER', getenv('WP_ADMIN_USER') ?: 'admin');
define('WP_ADMIN_PASSWORD', get_secret('WP_ADMIN_PASSWORD', '/run/secrets/db_root_password'));
define('WP_USER', getenv('WP_USER') ?: 'user');
define('WP_PASSWORD', get_secret('WP_PASSWORD', '/run/secrets/db_user_password'));

// -----------------
// Absolute path
// -----------------
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

// -----------------
// Bootstrap WordPress
// -----------------
require_once ABSPATH . 'wp-settings.php';
?>
