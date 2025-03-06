FROM spark:3.5.1-scala2.12-java11-ubuntu

USER root

RUN set -ex; \
    apt-get update; \
    apt-get install -y python3 python3-pip; \
    apt-get install -y r-base r-base-dev; \
    rm -rf /var/lib/apt/lists/*

    
ENV SPARK_VERSION=3.5.1 \
HADOOP_VERSION=3 \
SPARK_HOME=/opt/spark \
PATH=$SPARK_HOME/bin:$PATH

# AWS
# RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.353/aws-java-sdk-bundle-1.12.353.jar && \
#     wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar && \
#     mv aws-java-sdk-bundle-1.12.353.jar /opt/spark/jars/ && \
#     mv hadoop-aws-3.3.4.jar /opt/spark/jars/

# Spark Connect
# RUN wget https://repo1.maven.org/maven2/org/apache/spark/spark-connect_2.12/3.5.1/spark-connect_2.12-3.5.1.jar && \
#     mv spark-connect_2.12-3.5.1.jar /opt/spark/jars/

WORKDIR /opt/spark

ENV SPARK_MASTER_PORT=7077 \
SPARK_MASTER_WEBUI_PORT=8080 \
SPARK_LOG_DIR=/opt/spark/logs \
SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
SPARK_WORKER_WEBUI_PORT=8080 \
SPARK_WORKER_PORT=7000

COPY spark-defaults.conf $SPARK_HOME/conf/
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

EXPOSE 8080 7077 18080 15002 4040

RUN mkdir -p $SPARK_LOG_DIR && \
touch $SPARK_MASTER_LOG && \
touch $SPARK_WORKER_LOG && \
ln -sf /dev/stdout $SPARK_MASTER_LOG && \
ln -sf /dev/stdout $SPARK_WORKER_LOG

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]