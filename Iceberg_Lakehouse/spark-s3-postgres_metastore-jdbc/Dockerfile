FROM spark:3.5.6-scala2.12-java17-python3-r-ubuntu

USER root

ENV ICEBERG_VERSION=1.9.1 \
    AWS_SDK_VERSION=2.31.74 \
    SCALA_VERSION=2.12 \
    SPARK_HOME=/opt/spark \
    PATH=$SPARK_HOME/bin:$PATH

WORKDIR /tmp

RUN wget https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_SDK_VERSION}/bundle-${AWS_SDK_VERSION}.jar && \
    wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_${SCALA_VERSION}/${ICEBERG_VERSION}/iceberg-spark-runtime-3.5_${SCALA_VERSION}-${ICEBERG_VERSION}.jar && \
    wget https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.36/slf4j-simple-1.7.36.jar && \
    wget https://jdbc.postgresql.org/download/postgresql-42.7.3.jar && \
    mv *.jar /opt/spark/jars/ && \
    rm -rf /tmp/*

RUN mkdir -p $SPARK_HOME/logs && \
    mkdir -p $SPARK_HOME/conf && \
    touch $SPARK_HOME/logs/spark-master.out $SPARK_HOME/logs/spark-worker.out && \
    ln -sf /dev/stdout $SPARK_HOME/logs/spark-master.out && \
    ln -sf /dev/stdout $SPARK_HOME/logs/spark-worker.out

COPY spark-defaults.conf $SPARK_HOME/conf/
COPY log4j.properties $SPARK_HOME/conf/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080 7077 18080 15002 4040

ENTRYPOINT ["/entrypoint.sh"]
