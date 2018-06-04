#!/bin/sh
cd /opt/
KAFKA_NAME=$(ls)
mv $KAFKA_NAME kafka
KAFKA_HOME="/opt/kafka"
cd $KAFKA_HOME

supervisord -n