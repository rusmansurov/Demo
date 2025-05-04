#!/bin/bash
# scripts/produce.sh

TOPIC=${1:-my-topic}

echo "Producing messages to topic '$TOPIC'. Press Ctrl+D to finish."
docker exec -it kafka-1 kafka-console-producer.sh \
  --topic "$TOPIC" \
  --bootstrap-server kafka-1:9090