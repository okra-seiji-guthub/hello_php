<?php
/**
 * PHP Info Test Page
 * Test page to verify PHP, Redis, and MySQL connectivity
 */

echo "<h1>Hello PHP - Test Environment</h1>";
echo "<p>PHP Version: " . phpversion() . "</p>";

// Test Redis connection
echo "<h2>Redis Connection Test</h2>";
if (class_exists('Redis')) {
    try {
        $redis = new Redis();
        $redisHost = getenv('REDIS_HOST') ?: 'redis';
        $redisPort = getenv('REDIS_PORT') ?: 6379;
        
        if ($redis->connect($redisHost, $redisPort)) {
            $redis->set('test_key', 'Hello from Redis!');
            $value = $redis->get('test_key');
            echo "<p style='color: green;'>✓ Redis is connected! Test value: $value</p>";
        } else {
            echo "<p style='color: red;'>✗ Redis connection failed</p>";
        }
    } catch (Exception $e) {
        echo "<p style='color: red;'>✗ Redis error: " . $e->getMessage() . "</p>";
    }
} else {
    echo "<p style='color: red;'>✗ Redis extension not loaded</p>";
}

// Test MySQL connection
echo "<h2>MySQL Connection Test</h2>";
try {
    $dbHost = getenv('DB_HOST') ?: 'mysql';
    $dbName = getenv('DB_NAME') ?: 'hello_php';
    $dbUser = getenv('DB_USER') ?: 'root';
    $dbPass = getenv('DB_PASSWORD') ?: 'secret';
    
    $dsn = "mysql:host=$dbHost;dbname=$dbName";
    $pdo = new PDO($dsn, $dbUser, $dbPass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $stmt = $pdo->query('SELECT VERSION() as version');
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    echo "<p style='color: green;'>✓ MySQL is connected! Version: " . $result['version'] . "</p>";
} catch (PDOException $e) {
    echo "<p style='color: red;'>✗ MySQL connection failed: " . $e->getMessage() . "</p>";
}

echo "<h2>PHP Extensions</h2>";
echo "<ul>";
echo "<li>PDO MySQL: " . (extension_loaded('pdo_mysql') ? '✓ Loaded' : '✗ Not loaded') . "</li>";
echo "<li>Redis: " . (extension_loaded('redis') ? '✓ Loaded' : '✗ Not loaded') . "</li>";
echo "<li>MBString: " . (extension_loaded('mbstring') ? '✓ Loaded' : '✗ Not loaded') . "</li>";
echo "<li>Intl: " . (extension_loaded('intl') ? '✓ Loaded' : '✗ Not loaded') . "</li>";
echo "<li>GD: " . (extension_loaded('gd') ? '✓ Loaded' : '✗ Not loaded') . "</li>";
echo "</ul>";

phpinfo();
