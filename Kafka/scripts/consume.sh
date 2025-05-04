#!/bin/bash
# scripts/consume.sh

TOPIC=${1:-my-topic}

echo "Consuming messages from topic '$TOPIC'. Press Ctrl+C to stop."
docker exec -it kafka-1 kafka-console-consumer.sh \
  --bootstrap-server kafka-1:9090 \
  --topic "$TOPIC" \
  --from-beginning
