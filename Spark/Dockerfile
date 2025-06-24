FROM spark:4.0.0-scala2.13-java17-ubuntu

USER root

RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SPARK_VERSION=4.0.0 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/opt/spark \
    PATH=$SPARK_HOME/bin:$PATH

# Hadoop AWS
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar && \
    wget https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.29.6/bundle-2.29.6.jar && \
    mv hadoop-aws-3.4.1.jar bundle-2.29.6.jar /opt/spark/jars/

WORKDIR /opt/spark

ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 \
    SPARK_LOG_DIR=/opt/spark/logs \
    SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
    SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
    SPARK_WORKER_WEBUI_PORT=8080 \
    SPARK_WORKER_PORT=7000

RUN mkdir -p $SPARK_LOG_DIR $SPARK_HOME/conf && \
    touch $SPARK_MASTER_LOG $SPARK_WORKER_LOG && \
    ln -sf /dev/stdout $SPARK_MASTER_LOG && \
    ln -sf /dev/stdout $SPARK_WORKER_LOG

COPY spark-defaults.conf $SPARK_HOME/conf/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080 7077 18080 15002 4040

ENTRYPOINT ["/entrypoint.sh"]
