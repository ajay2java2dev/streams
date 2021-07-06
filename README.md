# Event Streaming 
Event Streaming Applications and stream management using Kafka, Kafka Connect (Sinks and Source), Zookeeper, Landoop, Confluent-Hub etc.

# oreilly-samples (landoop)
## Tutorial contains the complete code step by step. Checkout the code samples below.
.*
├── _tutorial
│   └── code
│       ├── docker-compose.yml
│       ├── kafka-connect-tutorial-sinks.sh
│       ├── kafka-connect-tutorial-sources.sh
│       ├── setup
│       │   ├── connect-distributed-2nd-worker.properties
│       │   ├── connect-distributed.properties
│       │   └── setup.sh
│       ├── sink
│       │   ├── demo-elasticsearch
│       │   │   ├── query-high-friends.json
│       │   │   ├── query-only-retweets.json
│       │   │   └── sink-elastic-twitter-distributed.properties
│       │   ├── demo-postgres
│       │   │   └── sink-postgres-twitter-distributed.properties
│       │   ├── demo-postgres-smt
│       │   └── demo-rest-api
│       │       └── demo-rest-api.sh
│       └── source
│           ├── demo-1
│           │   ├── demo-file.txt
│           │   ├── file-stream-demo-standalone.properties
│           │   ├── standalone.offsets
│           │   └── worker.properties
│           ├── demo-2
│           │   └── file-stream-demo-distributed.properties
│           └── demo-3
│               └── source-twitter-distributed.properties



## Sample Twitter Integration
.*

└── twitter-kafka-elastic-postgres
    ├── docker-compose.yml
    ├── source-twitter-distributed.properties
    └── twitter-kafka-elastic-postgres.sh

### 1. Docker compose and connector properties.
<p>This folder contain a simple shell script (twitter-kafka-elastic-postgres.sh) to run all the required steps.</p>

    $ docker-compose up kafka-cluster elasticsearch postgres
    $ docker run --rm -it --net=host landoop/fast-data-dev bash
    $ kafka-topics --create --topic source_twitter_topic_tweets_ajay1 --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
    
    - Testing: Start a console consumer on that topic
    $ kafka-console-consumer --topic source_twitter_topic_tweets_ajay1 --bootstrap-server 127.0.0.1:9092


### 2. docker ps
| IMAGE  | PORTS | DESCRIPTION |
| ------------- | ------------- | ------------- |
| landoop/fast-data-dev:latest  |  0.0.0.0:2181->2181/tcp, 0.0.0.0:3030->3030/tcp, 0.0.0.0:8081-8083->8081-8083/tcp, 0.0.0.0:9092->9092/tcp, 0.0.0.0:9581-9585->9581-9585/tcp, 3031/tcp  | Source Topic Name: source_twitter_topic_tweets_ajay1, Sink Topic Name: source_twitter_topic_tweets_ajay1
| itzg/elasticsearch:2.4.3  | 0.0.0.0:9200->9200/tcp, 9300/tcp  | http://0.0.0.0:9200/ - elasticsearch health check|
| postgres:9.5-alpine  | 0.0.0.0:5432->5432/tcp  |




# confluent-samples