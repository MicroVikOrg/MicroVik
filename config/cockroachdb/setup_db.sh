#!/bin/bash
echo Wait for servers to be up
sleep 10

HOSTPARAMS="--host roach-node --insecure"
/cockroach/cockroach.sh init $HOSTPARAMS
SQL="/cockroach/cockroach.sh sql $HOSTPARAMS"

$SQL -e "CREATE DATABASE microvikdb;"
$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN,
    node_id UUID DEFAULT NULL
);"

$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS chats (
    id UUID PRIMARY KEY,
    chatname VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);"

$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS messages (
    message_id UUID PRIMARY KEY,
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    node_id UUID NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);"

$SQL -d microvikdb -e "CREATE TABLE IF NOT EXISTS chat_members(
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (chat_id, user_id)
);"