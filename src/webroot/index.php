<?php
// 例: PDOで接続する場合
$dsn = 'mysql:host=db;dbname=my_database;charset=utf8';
$user = 'user';
$password = 'password';

try {
    $dbh = new PDO($dsn, $user, $password);
    echo "connected successfully";
    echo "<p>" . $dbh->getAttribute(PDO::ATTR_CONNECTION_STATUS) . "</p>";
} catch (PDOException $e) {
    echo "connection failed: " . $e->getMessage();
}
