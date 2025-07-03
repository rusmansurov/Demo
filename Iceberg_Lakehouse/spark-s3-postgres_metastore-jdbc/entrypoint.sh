#!/bin/bash

set -e

echo "SPARK_MODE=${SPARK_MODE}"

case "$SPARK_MODE" in
  master)
    echo "Starting Spark Master..."
    /opt/spark/sbin/start-master.sh
    tail -f /opt/spark/logs/spark--org.apache.spark.deploy.master*.out
    ;;
    
  worker)
    echo "Starting Spark Worker..."
    if [ -z "$SPARK_MASTER" ]; then
      echo "ERROR: SPARK_MASTER is not set"
      exit 1
    fi
    /opt/spark/sbin/start-worker.sh "$SPARK_MASTER"
    tail -f /opt/spark/logs/spark--org.apache.spark.deploy.worker*.out
    ;;
    
  history)
    echo "Starting Spark History Server..."
    mkdir -p /tmp/spark-events
    /opt/spark/sbin/start-history-server.sh
    tail -f /opt/spark/logs/spark--org.apache.spark.deploy.history*.out
    ;;

  client)
    echo "Spark client container — entering interactive bash shell."
    exec /bin/bash
    ;;

  *)
    echo "Unknown SPARK_MODE: ${SPARK_MODE}"
    echo "Available modes: master, worker, history, client"
    exec "$@"
    ;;
esac
