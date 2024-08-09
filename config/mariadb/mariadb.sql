INSTALL SONAME 'ha_spider';

SET GLOBAL sql_mode='';

DROP DATABASE IF EXISTS microvikdb;

CREATE DATABASE microvikdb;

USE microvikdb;


## Example of credentials saved in SERVER
CREATE SERVER IF NOT EXISTS xpand1
FOREIGN DATA WRAPPER mariadb
OPTIONS (
   HOST "xpd1",
   PORT 3306,
   USER "importuser",
   PASSWORD "importuserpasswd",
   DATABASE "microvikdb"
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    deleted_at DATETIME DEFAULT NULL,
    token TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS chats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chat_name VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    chat_id INT,
    sender_id INT,
    content TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chat_id) REFERENCES chats(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chatMembers (
    chat_id INT,
    user_id INT,
    PRIMARY KEY (chat_id, user_id),
    FOREIGN KEY (chat_id) REFERENCES chats(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);