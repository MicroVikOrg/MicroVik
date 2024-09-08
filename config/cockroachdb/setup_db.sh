#!/bin/bash
echo Wait for servers to be up
sleep 10

HOSTPARAMS="--host roach-node --insecure"
SQL="/cockroach/cockroach.sh sql $HOSTPARAMS"

$SQL -e "CREATE DATABASE microvikdb;"
$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    token TEXT DEFAULT NULL
);"

$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS chats (
    id SERIAL PRIMARY KEY,
    chat_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);"

$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    chat_id INT REFERENCES chats(id) ON DELETE CASCADE,
    sender_id INT REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);"

$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS chatMembers(
    chat_id INT REFERENCES chats(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (chat_id, user_id)
);"