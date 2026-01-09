SET NAMES utf8mb4;

-- テーブルの作成
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


-- テストデータの挿入
INSERT INTO users (name, email) VALUES 
('田中 太郎', 'tanaka@example.com'),
('佐藤 花子', 'sato@example.com'),
('鈴木 一郎', 'suzuki@example.com');

INSERT INTO posts (user_id, title, content) VALUES 
(1, '最初の投稿', 'Dockerでのデータベース接続に成功しました！'),
(2, 'PHP 7.2の思い出', '昔のプロジェクトを動かすのに便利ですね。'),
(3, 'MySQLの学習', '初期データの投入方法を学んでいます。'),
(2, 'Web開発', 'DockerとPHPでの開発が楽しいです。'),
(2, 'セキュリティ対策', 'ユーザー認証について考えています。');

ALTER USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
FLUSH PRIVILEGES;
