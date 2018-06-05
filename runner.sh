#!/bin/sh

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
   
while [ ! "$REPLICAS" -eq 0 ]; do
    echo "Creating kafka server with id= $REPLICAS"
    cp /opt/server.properties $KAFKA_HOME/config/server-$REPLICAS.properties
    sed -i "s,{broker_id},$REPLICAS,g" $KAFKA_HOME/config/server-$REPLICAS.properties
    sed -i "s,{host_port},909$REPLICAS,g" $KAFKA_HOME/config/server-$REPLICAS.properties

    cp /opt/kafka.template /etc/supervisor.d/kafka-$REPLICAS.ini
    sed -i "s,{broker_id},$REPLICAS,g" /etc/supervisor.d/kafka-$REPLICAS.ini

    : $((REPLICAS-=1))
done

supervisord -n