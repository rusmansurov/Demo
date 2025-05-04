#!/bin/bash
# scripts/create-topic.sh

TOPIC=${1:-my-topic}
PARTITIONS=1
REPLICATION=1

echo "Creating topic '$TOPIC'..."
docker exec -it kafka-1 kafka-topics.sh \
  --create \
  --topic "$TOPIC" \
  --bootstrap-server kafka-1:9090 \
  --partitions $PARTITIONS \
  --replication-factor $REPLICATION
