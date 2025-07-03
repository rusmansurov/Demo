#!/bin/bash
set -e

echo "Spark Mode: $SPARK_MODE"
echo "Starting at $(date)"

trap "echo 'Stopping Spark...'" SIGTERM

case "$SPARK_MODE" in
  master)
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master
    ;;
  worker)
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker "$SPARK_MASTER"
    ;;
  history)
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.history.HistoryServer
    ;;
  *)
    echo "Unknown SPARK_MODE: $SPARK_MODE. Running default command: $@"
    exec "$@"
    ;;
esac
