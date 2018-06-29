## What is this ?

This repository provides everything you need to operate kafka in single broker or multi broker state, with a zookeper in front of them.

## Environment Variables
| ENV | DESC |DEFAULT VALUE|
| --- | --- | ---|
| BROKER_REPLICAS | Number of Brokers | 3|
| ADVERTISED_HOST | Machine IP Address| N/A|

## Run
```
docker run -d \
        --env BROKER_REPLICAS=1 \
        --env ADVERTISED_HOST=`machine ip` \
        -p 2181:2181 \
        -p 9092:9092 \
        -it tanigroup/alpine-kafka
```

*2181 is Zookeeper port and 9092 are kafka port*
*Please adjust your kafka port based on BROKER_REPLICAS*
