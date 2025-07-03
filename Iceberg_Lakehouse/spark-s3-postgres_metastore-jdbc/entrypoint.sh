#!/bin/bash
set -e

case "$SPARK_MODE" in
  master)
    echo "Starting Spark Master..."
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master
    ;;
  worker)
    echo "Starting Spark Worker..."
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER
    ;;
  history)
    echo "Starting Spark History Server..."
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.history.HistoryServer
    ;;
  *)
    echo "Unknown SPARK_MODE: $SPARK_MODE. Running default command: $@"
    exec "$@"
    ;;
esac
