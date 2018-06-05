FROM tanigroup/alpine-openjdk-8-jre

RUN apk --update add supervisor wget bash && \
    wget -q http://www-us.apache.org/dist/kafka/1.1.0/kafka_2.12-1.1.0.tgz -O kafka.tgz && \
    mkdir -p /opt && \
    tar xfz kafka.tgz -C /opt && \
    rm -rf kafka.tgz
ADD runner.sh /usr/local/bin
RUN mv /usr/local/bin/runner.sh /usr/local/bin/runner && \
    chmod +x /usr/local/bin/runner

ADD kafka/server.properties /opt/
ADD supervisor/zookeeper.ini /etc/supervisor.d/
ADD supervisor/kafka.template /opt/

CMD ["runner"]
