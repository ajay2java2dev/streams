## Bring all required services up
sudo docker-compose up kafka-cluster elasticsearch postgres
## Get into landoop bash to execute kafka commands
sudo docker run --rm -it --net=host landoop/fast-data-dev:cp3.3.0 bash
## Create the Source topic we want.
kafka-topics --create --topic source_twitter_topic_geek_tweets --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
## Alter default config, add compact policy
kafka-configs --zookeeper 127.0.0.1:2181 --entity-type topics --entity-name source_twitter_topic_geek_tweets --alter --add-config "cleanup.policy=[delete,compact]"

## Execute the below command to create the connector

curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "source-twitter-geek-tweets-distributed",
  "config": {
    "connector.class": "com.eneco.trading.kafka.connect.twitter.TwitterSourceConnector",
    "tasks.max": "1",
    "topics": "source_twitter_topic_geek_tweets",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true",
    "twitter.consumerkey": "",
    "twitter.consumersecret": "",
    "twitter.token": "",
    "twitter.secret": "",
    "track.terms": "programming,java,kafka,scala,R,google,apache,confluent",
    "language": "en"
  }
}'



## Create the Sink topic we want.
kafka-topics --create --topic sink_twitter_topic_geek_tweets --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
## Alter default config, add compact policy
kafka-configs --zookeeper 127.0.0.1:2181 --entity-type topics --entity-name sink_twitter_topic_geek_tweets --alter --add-config "cleanup.policy=[delete,compact]"
