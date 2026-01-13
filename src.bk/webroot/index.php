<!DOCTYPE html>
<header>
    <meta charset="UTF-8">
    <html lang="ja">
    <title>Hello PHP</title>
</header>

<body>
    <h1>Hello PHP</h1>
    <?php
    // 例: PDOで接続する場合
    //$dsn = 'mysql:host=db;dbname=my_database;charset=utf8';
    $dsn = 'mysql:host=db;dbname=my_database;charset=utf8mb4';
    $user = 'user';
    $password = 'password';

    try {
        $options = array(
            PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4',
        );
        $dbh = new PDO($dsn, $user, $password, $options);
        echo "connected successfully";
        echo "<p>" . $dbh->getAttribute(PDO::ATTR_CONNECTION_STATUS) . "</p>";
        // データベースから値を取ってきたり、 データを挿入したりする処理 
        $statement = $dbh->query('SELECT * FROM users');
        echo "<h2>Users List:</h2>";
        echo "<ul>";
        while ($user = $statement->fetch()) {
            echo "<li>";
            printf("%s is %d years old.\n", $user['name'], $user['age']);
            echo "</li>";
        }
        echo "</ul>";
        //phpinfo();
    } catch (PDOException $e) {
        echo "connection failed: " . $e->getMessage();
    }
    ?>
</body>