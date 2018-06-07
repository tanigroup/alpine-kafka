#!/bin/bash

if [[ -z "$ADVERTISED_HOST" ]]; then
    echo "Please provide ADVERTISED_HOST"
    exit 0
fi

cd /opt/
KAFKA_NAME=$(ls -d */ | cut -f1 -d'/')
mv $KAFKA_NAME kafka
KAFKA_HOME="/opt/kafka"
cd $KAFKA_HOME

REPLICAS=3
if [[ -z "$BROKER_REPLICAS" ]]; then
    echo "ENV is not set, set broker replicas to 3"
else
    echo "ENV is set, set broker replicas to $BROKER_REPLICAS"
    REPLICAS=$BROKER_REPLICAS
fi
rm -rf $KAFKA_HOME/config/server.properties

for (( i=0 ; ((i-$REPLICAS)) ; i=(($i+1)) ))
do
    PORT=9092
    KAFKA_PORT=$(($PORT+$i))

    echo "Creating kafka server with id= $i"
    cp /opt/server.properties $KAFKA_HOME/config/server-$i.properties
    sed -i "s,{broker_id},$i,g" $KAFKA_HOME/config/server-$i.properties
    sed -i "s,{host_port},$KAFKA_PORT,g" $KAFKA_HOME/config/server-$i.properties
    sed -i "s,{host_name},$ADVERTISED_HOST,g" $KAFKA_HOME/config/server-$i.properties

    cp /opt/kafka.template /etc/supervisor.d/kafka-$i.ini
    sed -i "s,{broker_id},$i,g" /etc/supervisor.d/kafka-$i.ini
done;

supervisord -n