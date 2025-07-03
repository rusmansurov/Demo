FROM spark:4.0.0-scala2.13-java17-python3-r-ubuntu

USER root

ENV SPARK_HOME=/opt/spark \
    PATH=$SPARK_HOME/bin:$PATH

WORKDIR $SPARK_HOME

RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.1/hadoop-aws-3.4.1.jar && \
    wget https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.29.6/bundle-2.29.6.jar && \
    mv hadoop-aws-3.4.1.jar bundle-2.29.6.jar /opt/spark/jars/

ENV SPARK_LOG_DIR=$SPARK_HOME/logs

RUN mkdir -p $SPARK_LOG_DIR $SPARK_HOME/conf && \
    rm -f $SPARK_MASTER_LOG $SPARK_WORKER_LOG && \
    ln -sf /dev/stdout $SPARK_MASTER_LOG && \
    ln -sf /dev/stdout $SPARK_WORKER_LOG

COPY spark-defaults.conf $SPARK_HOME/conf/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7077 8080 18080 4040 15002

ENTRYPOINT ["/entrypoint.sh"]
