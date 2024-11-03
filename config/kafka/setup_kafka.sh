#!/bin/bash
echo Wait for servers to be up
sleep 10

kafka-topics --create --topic verified_emails --partitions 20  --bootstrap-server kafka:9092